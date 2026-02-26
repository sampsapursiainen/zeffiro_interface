function outTree = zef_simulate_jr_tree(treeStruct, gd)
%ZEF_SIMULATE_JR_TREE Delay-free JR network simulation with looped passes.
%
% ODE45 version (single-file, no external dependencies).
%
% New-name version (NO legacy aliases):
%   gd.blockDuration_s, gd.samplingRate_Hz, gd.gaussianNoiseStd, gd.numFeedbackLoops, ...
%   gd.externalInput_*, gd.modulation_*
%
%   nd.SourceNoise, nd.ModelParameters.excSynapticGain_mV, ..., nd.Connectivity.*
%
% Rules:
%  1) No transport delays in the solver. All nodes simulate on t in [0,T_s].
%  2) Child input is parent's undelayed upRaw (same pass).
%  3) Pass 1 root input is external qext(t).
%  4) Pass p>1 root input is loop-feedback from pass p-1 leaf outputs (undelayed),
%     according to Connectivity.ToRoots and Connectivity.RootTargets.
%  5) Outputs are Nt x nPass for each node (Vp,Vpe,Vpi,upRaw,qpRaw).
%
% Delays are handled ONLY in publishing: zef_publish_jr_tree_delays.m
%
% IMPORTANT NOTE ABOUT NOISE:
%  ode45 uses adaptive internal time steps. Calling randn() inside the RHS
%  makes results step-size dependent and non-reproducible. Therefore, noise
%  is pre-sampled on the output grid and injected via interpolation.

    if nargin < 2
        error('zef_simulate_jr_tree:InvalidInput', 'Provide (treeStruct, gd).');
    end

    % --- Time base ---
    T_s = nvget(gd, 'blockDuration_s', 1.0);
    fs  = nvget(gd, 'samplingRate_Hz', 1000);
    dt  = 1/fs;
    Nt  = max(2, floor(T_s*fs) + 1);
    t   = (0:Nt-1)'*dt;

    sigma_global = nvget(gd, 'gaussianNoiseStd', 0.0);
    nLoops       = max(0, round(nvget(gd, 'numFeedbackLoops', 0)));
    nPass        = nLoops + 1;

    % External drive used in pass 1 by default
    qext = make_external_input(t, gd);

    % --- Flatten node metadata (parent-before-children order) ---
    flat = flatten_tree_meta(treeStruct);

    % Prealloc outputs per node
    for i = 1:flat.N
        flat.out{i}.t     = t;
        flat.out{i}.Vp    = zeros(Nt, nPass);
        flat.out{i}.Vpe   = zeros(Nt, nPass);
        flat.out{i}.Vpi   = zeros(Nt, nPass);
        flat.out{i}.upRaw = zeros(Nt, nPass);   % Vpe - Vpi (undelayed)
        flat.out{i}.qpRaw = zeros(Nt, nPass);   % input given to solver (undelayed)
    end

    rootIdx   = flat.rootIdx(:);
    rootNames = flat.rootNames(:);
    nRoots    = numel(rootIdx);

    % Root input signals for next pass (Nt x nRoots)
    rootInNext = zeros(Nt, nRoots);

    % --- Pass loop ---
    for pass = 1:nPass

        % Root input for this pass (undelayed)
        if pass == 1
            rootInThis = repmat(qext, 1, nRoots);
        else
            rootInThis = rootInNext;
        end

        % clear for building next pass
        rootInNext(:,:) = 0;

        % ---- Root input interpolants (deterministic) ----
        rootFun = cell(nRoots,1);
        for r = 1:nRoots
            sig = rootInThis(:,r);
            rootFun{r} = @(tt) interp1(t, sig, tt, 'linear', 'extrap');
        end

        % ---- Precompute per-node parameters + noise interpolants ----
        parArr   = cell(flat.N,1);
        noiseFun = cell(flat.N,1);
        for i = 1:flat.N
            nd = flat.node{i}.NodeData;
            parArr{i} = nodedata_to_par(nd);

            sigma_node  = nvget_nested(nd, {'SourceNoise'}, 0.0);
            sigma_total = sigma_global + sigma_node;

            if sigma_total > 0
                % noise sampled on output grid; interpolated for ode45
                eta = sigma_total * randn(Nt,1);
                noiseFun{i} = @(tt) interp1(t, eta, tt, 'linear', 'extrap');
            else
                noiseFun{i} = @(tt) 0.0;
            end
        end

        % ---- Initial conditions (each pass starts from zero) ----
        X0 = zeros(6*flat.N, 1);

        % ---- Coupled RHS for the whole tree ----
        rhs = @(tt, X) jr_tree_rhs(tt, X, flat, parArr, rootIdx, rootFun, noiseFun);

        % Solver options:
        % MaxStep=dt makes it behave closer to your original per-sample stepping.
        opts = odeset('RelTol',1e-5,'AbsTol',1e-8,'MaxStep',dt);

        % Important: pass vector t to sample solution at your grid points
        [~, Xsol] = ode45(rhs, t, X0, opts);

        % ---- Unpack solution into outputs for this pass ----
        for i = 1:flat.N

            nd  = flat.node{i}.NodeData;
amp = db2mag(nvget_nested(nd, {'OutputGain'}, 1.0));

            Xsol(:, (6*(i-1)+1):end) = amp*Xsol(:, (6*(i-1)+1):end);
            cols = (6*(i-1)+1):(6*i);
            Xi = Xsol(:, cols);

            Vp  = Xi(:,1);
            Vpe = Xi(:,3);
            Vpi = Xi(:,5);
            
upCouple = Vpe - Vpi;
flat.out{i}.upRaw(:,pass) = upCouple;   % output only

            flat.out{i}.Vp(:,pass)    =  Vp;
            flat.out{i}.Vpe(:,pass)   = Vpe;
            flat.out{i}.Vpi(:,pass)   =  Vpi;

            % Reconstruct qpRaw on grid deterministically from Xsol + interpolants
            flat.out{i}.qpRaw(:,pass) = jr_tree_qp_on_grid(t, Xsol, i, flat, rootIdx, rootFun, noiseFun);
        end

        % --- Build loop input for NEXT pass from leaf outputs of THIS pass ---
        if pass < nPass
            for li = 1:numel(flat.leafIdx)
                iLeaf  = flat.leafIdx(li);
                ndLeaf = flat.node{iLeaf}.NodeData;

                toRoots = logical(nvget_nested(ndLeaf, {'Connectivity','ToRoots'}, 0));
                if ~toRoots
                    continue;
                end

                targets = nvget_nested(ndLeaf, {'Connectivity','RootTargets'}, '');
                targetList = parse_targets(targets);
                if isempty(targetList)
                    continue;
                end

                leafSig = flat.out{iLeaf}.upRaw(:, pass);

                for tj = 1:numel(targetList)
                    rname = targetList{tj};
                    rpos  = find(strcmp(rootNames, rname), 1, 'first');
                    if ~isempty(rpos)
                        rootInNext(:, rpos) = rootInNext(:, rpos) + leafSig;
                    end
                end
            end
        end
    end

    outTree = rebuild_tree_with_outputs(treeStruct, flat);

    % optional metadata
    outTree.samplingRate_Hz   = fs;
    outTree.blockDuration_s   = T_s;
    outTree.nPass             = nPass;
end

%% ========================================================================
%% Coupled RHS for the full tree (ode45)
function dX = jr_tree_rhs(tt, X, flat, parArr, rootIdx, rootFun, noiseFun)
%JR_TREE_RHS Coupled JR network RHS for ode45.
% X is (6N)x1 stacked [node1; node2; ...], each node has 6 states.
% Wiring (undelayed):
%   - roots take qp from rootFun{r}(t)
%   - children take qp = up_parent = (Vpe_parent - Vpi_parent)
% Noise:
%   qp += noiseFun{i}(t)  (deterministic interpolant)

    N = flat.N;
    Xmat = reshape(X, 6, N);

    % up(t) for all nodes from current state
    upAll = Xmat(3,:) - Xmat(5,:);  % Vpe - Vpi, 1xN

    dXmat = zeros(6, N);

    % node index -> root position (0 if not a root)
    rootPos = zeros(1,N);
    for r = 1:numel(rootIdx)
        rootPos(rootIdx(r)) = r;
    end

    for i = 1:N
        % compute qp for node i
        if flat.parent(i) == 0
            r = rootPos(i);
            if r > 0
                qp = rootFun{r}(tt);
            else
                qp = 0; % fallback
            end
        else
            p = flat.parent(i);
            qp = upAll(p);
        end

        qp = qp + noiseFun{i}(tt);

        dXmat(:,i) = jr445_rhs(tt, Xmat(:,i), parArr{i}, qp);
    end

    dX = dXmat(:);
end

%% ========================================================================
%% Reconstruct qp(t_k) on the output grid from Xsol + interpolants
function qp = jr_tree_qp_on_grid(t, Xsol, iNode, flat, rootIdx, rootFun, noiseFun)

    Nt = numel(t);
    N  = flat.N;
    qp = zeros(Nt,1);

    rootPos = zeros(1,N);
    for r = 1:numel(rootIdx)
        rootPos(rootIdx(r)) = r;
    end

    for k = 1:Nt
        Xk = reshape(Xsol(k,:), 6, N);
        upAll = Xk(3,:) - Xk(5,:);

        if flat.parent(iNode) == 0
            r = rootPos(iNode);
            if r > 0
                qpk = rootFun{r}(t(k));
            else
                qpk = 0;
            end
        else
            p = flat.parent(iNode);
            qpk = upAll(p);
        end

        qp(k) = qpk + noiseFun{iNode}(t(k));
    end
end

%% ========================================================================
%% Flatten meta (nodes only; builds parent pointers and root list)
function flat = flatten_tree_meta(treeStruct)
    flat.node = {};
    flat.out  = {};
    flat.path = {};
    flat.parent = [];
    flat.children = {};
    flat.rootIdx = [];
    flat.rootNames = {};
    idx = 0;

    reserved = {'Text','UserData','NodeData','t','Vp','Vpe','Vpi','up','upRaw','qpRaw',...
                'samplingRate_Hz','blockDuration_s','nPass'};

    function tf = is_node_struct(x)
        tf = isstruct(x) && isfield(x,'NodeData');
    end

    function add_node(nodeStruct, parentIdx, path, rootNameIfAny)
        idx = idx + 1;
        thisIdx = idx;

        meta = struct('Text',[],'UserData',[],'NodeData',[]);
        if isfield(nodeStruct,'Text'),     meta.Text     = nodeStruct.Text;     end
        if isfield(nodeStruct,'UserData'), meta.UserData = nodeStruct.UserData; end
        meta.NodeData = nodeStruct.NodeData;

        flat.node{thisIdx} = meta;
        flat.out{thisIdx}  = struct();

        flat.path{thisIdx}     = path;
        flat.parent(thisIdx)   = parentIdx;
        flat.children{thisIdx} = [];

        if parentIdx == 0
            flat.rootIdx(end+1)   = thisIdx; %#ok<AGROW>
            flat.rootNames{end+1} = rootNameIfAny; %#ok<AGROW>
        else
            flat.children{parentIdx}(end+1) = thisIdx; %#ok<AGROW>
        end

        fn = fieldnames(nodeStruct);
        for k = 1:numel(fn)
            nm = fn{k};
            if any(strcmp(nm, reserved)), continue; end
            v = nodeStruct.(nm);
            if is_node_struct(v)
                add_node(v, thisIdx, [path '.' nm], '');
            end
        end
    end

    if ~isstruct(treeStruct)
        error('flatten_tree_meta:InvalidInput', 'treeStruct must be a struct.');
    end

    roots = fieldnames(treeStruct);
    for r = 1:numel(roots)
        rname = roots{r};
        v = treeStruct.(rname);
        if is_node_struct(v)
            add_node(v, 0, rname, rname);
        end
    end

    flat.N = idx;

    isLeaf = true(flat.N,1);
    for i = 1:flat.N
        if ~isempty(flat.children{i}), isLeaf(i) = false; end
    end
    flat.leafIdx = find(isLeaf);
end

%% ========================================================================
%% Rebuild tree with outputs
function out = rebuild_tree_with_outputs(templateTree, flat)
    out = templateTree;
    if ~isstruct(out), return; end

    fn = fieldnames(out);
    for k = 1:numel(fn)
        if isstruct(out.(fn{k}))
            out.(fn{k}) = rebuild_node(out.(fn{k}), fn{k});
        end
    end

    function s = rebuild_node(s, path)
        if ~isstruct(s), return; end

        i = find(strcmp(flat.path, path), 1, 'first');
        if ~isempty(i)
            s.t     = flat.out{i}.t;
            s.Vp    = flat.out{i}.Vp;
            s.Vpe   = flat.out{i}.Vpe;
            s.Vpi   = flat.out{i}.Vpi;
            s.upRaw = flat.out{i}.upRaw;
            s.qpRaw = flat.out{i}.qpRaw;
        end

        subf = fieldnames(s);
        reserved = {'Text','UserData','NodeData','t','Vp','Vpe','Vpi','up','upRaw','qpRaw'};
        for jj = 1:numel(subf)
            nm = subf{jj};
            if any(strcmp(nm, reserved)), continue; end
            if isstruct(s.(nm)) && isfield(s.(nm),'NodeData')
                s.(nm) = rebuild_node(s.(nm), [path '.' nm]);
            end
        end
    end
end

%% ========================================================================
%% NEW-NAME NodeData -> parameter vector for JR RHS
function par = nodedata_to_par(nd)
    mp = nd.ModelParameters;

    % Synaptic gains / rate constants
    par.A = mp.excSynapticGain_mV.Value;
    par.B = mp.inhSynapticGain_mV.Value;
    par.a = mp.excRateConstant_inv_s.Value;
    par.b = mp.inhRateConstant_inv_s.Value;

    % Coupling gains
    par.cp_e   = mp.gain_pyr_to_exc.Value;
    par.cp_i   = mp.gain_pyr_to_inh.Value;
    par.nu_e_p = mp.gain_exc_to_pyr.Value;
    par.nu_i_p = mp.gain_inh_to_pyr.Value;

    % Sigmoid
    par.e0 = mp.maxFiringRate_Hz.Value;
    par.v0 = mp.firingThreshold_mV.Value;
    par.r  = mp.firingSlope_per_mV.Value;
end

%% ========================================================================
%% External input using NEW-NAME gd fields only
function q = make_external_input(t, gd)
    shape = nvget(gd, 'externalInput_shape', 'box');
    q0    = nvget(gd, 'externalInput_baseline', 80);
    A     = nvget(gd, 'externalInput_amplitude', 80);
    t0    = nvget(gd, 'externalInput_onset_s', 0.10);
    dur   = nvget(gd, 'externalInput_duration_s', 0.50);

    gate = double(t >= t0 & t <= (t0 + dur));

    switch lower(char(string(shape)))
        case 'box'
            w = gate;
        case 'blackmanharris'
            w = blackmanharris_window(t, t0, dur) .* gate;
        otherwise
            w = gate;
    end

    q = q0 + A*w;

    if logical(nvget(gd, 'modulation_enabled', false))
        typ   = nvget(gd, 'modulation_waveform', 'sin');
        fmod  = nvget(gd, 'modulation_freq_Hz', 10.0);
        depth = nvget(gd, 'modulation_depth', 1.0);
        ph    = nvget(gd, 'modulation_phase_rad', 0.0);

        ang = 2*pi*fmod*t + ph;
        if strcmpi(typ,'cos'), m = cos(ang); else, m = sin(ang); end
        q = q0 + (q - q0).*(1 + depth*m);
    end
end

function w = blackmanharris_window(t, t0, dur)
    tau = (t - t0) / max(dur, eps);
    tau = max(0, min(1, tau));
    a0 = 0.35875; a1 = 0.48829; a2 = 0.14128; a3 = 0.01168;
    w = a0 - a1*cos(2*pi*tau) + a2*cos(4*pi*tau) - a3*cos(6*pi*tau);
end

%% ========================================================================
%% JR RHS (unchanged math)
function dx = jr445_rhs(~, x, par, qp_e)
    Vp    = x(1);  Vp_d  = x(2);
    Vpe   = x(3);  Vpe_d = x(4);
    Vpi   = x(5);  Vpi_d = x(6);

    f1 = sigmoid(Vpe - Vpi, par);
    f2 = sigmoid(par.nu_e_p * Vp, par);
    f3 = sigmoid(par.nu_i_p * Vp, par);

    Vp_dd  = par.A*par.a*f1 - 2*par.a*Vp_d   - (par.a^2)*Vp;
    Vpe_dd = par.A*par.a*(par.cp_e*f2 + qp_e) - 2*par.a*Vpe_d - (par.a^2)*Vpe;
    Vpi_dd = par.B*par.b*(par.cp_i*f3)        - 2*par.b*Vpi_d - (par.b^2)*Vpi;

    dx = zeros(6,1);
    dx(1) = Vp_d;
    dx(2) = Vp_dd;
    dx(3) = Vpe_d;
    dx(4) = Vpe_dd;
    dx(5) = Vpi_d;
    dx(6) = Vpi_dd;
end

function y = sigmoid(v, par)
    y0 = (2*par.e0) ./ (1 + exp(par.r*(par.v0)));      % sigmoid(0)
    y  = (2*par.e0) ./ (1 + exp(par.r*(par.v0 - v))) - y0;
end


%% ========================================================================
%% NV getters (NEW-NAME friendly)
function v = nvget(s, field, default)
    if isstruct(s) && isfield(s, field) && isstruct(s.(field)) && isfield(s.(field),'Value')
        v = s.(field).Value;
    else
        v = default;
    end
end

function v = nvget_nested(nd, pathCells, default)
    v = default;
    if isempty(nd) || ~isstruct(nd), return; end
    cur = nd;
    for k = 1:numel(pathCells)
        p = pathCells{k};
        if isfield(cur, p)
            cur = cur.(p);
        else
            return;
        end
    end
    if isstruct(cur) && isfield(cur,'Value'), v = cur.Value; else, v = cur; end
end

function targets = parse_targets(s)
    if isempty(s), targets = {}; return; end
    s = char(string(s));
    parts = regexp(s, '[,;]', 'split');
    parts = strtrim(parts);
    targets = parts(~cellfun(@isempty, parts));
end
