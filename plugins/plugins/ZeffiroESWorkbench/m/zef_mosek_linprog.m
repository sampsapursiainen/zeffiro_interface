function [x,fval,exitflag] = zef_mosek_linprog(f,A,b,Aeq,beq,lb,ub,options)

exitflag = -1;
fval     = []; 
x = [];

if nargin < 4
 Aeq = [];
end

if nargin < 5
beq = [];
end

if nargin > 5
    if not(isempty(lb))
model.lb = lb;
else 
    model.lb = -Inf*ones(size(A,2),1);
    end
    end

if nargin > 6
    if not(isempty(ub))
model.ub = ub;
else 
  model.ub = Inf*ones(size(A,2),1);
    end
end

[cmd,verb,param] = msksetup(1,options);
param.MSK_DPAR_INTPNT_TOL_REL_GAP = options.TolFun;
param.MSK_DPAR_BASIS_TOL_X = options.TolFun;
param.MSK_DPAR_BASIS_TOL_S = options.TolFun;
param.MSK_DPAR_OPTIMIZER_MAX_TIME = options.MaxTime;
if isequal(lower(options.Algorithm),'interior-point')
param.MSK_IPAR_OPTIMIZER = 'MSK_OPTIMIZER_INTPNT';
elseif isequal(lower(options.Algorithm),'primal-simplex')
  param.MSK_IPAR_OPTIMIZER = 'MSK_OPTIMIZER_PRIMAL_SIMPLEX';  
  elseif isequal(lower(options.Algorithm),'dual-simplex')
  param.MSK_IPAR_OPTIMIZER = 'MSK_OPTIMIZER_DUAL_SIMPLEX'; 
end

n                = length(f); 
[r,b,beq,lb,ub]      = mskcheck('linprog',verb,n,size(A),b,size(Aeq),beq,lb,ub);

if not(isequal(r,0))
   exitflag = r;
   output   = []; 
   fval     = []; 
   lambda   = [];
   return;
end   

model        = [];
[n_ineq,t] = size(A);
[n_eq,t]   = size(Aeq);
model.c      = reshape(f,n,1);
model.a      = [A;Aeq];
if ( isempty(model.a) )
   model.a = sparse(0,length(f));
elseif not(issparse(model.a))
   model.a = sparse(model.a);
end   
model.blc    = [-inf*ones(size(b));beq];
model.buc    = [b;beq];
model.blx    = lb;
model.bux    = ub;

clear f A b B beq lb ub options;
[rcode,res] = mosekopt(cmd,model,param);

mskstatus('linprog',verb,0,rcode,res);
 
if ( isfield(res,'sol') )
  if ( isfield(res.sol,'itr') )
    x = res.sol.itr.xx;
  else
    x = res.sol.bas.xx;
  end
else
  x = [];
end

if isequal(length(model.c), length(x))
   fval = model.c'*x; 
else
  fval = [];
end

   exitflag = mskeflag(rcode,res); 

end