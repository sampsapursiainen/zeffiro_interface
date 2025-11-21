function dti_streamlines = zef_dti_streamlines(dti_directions,dti_anisotropy,seed_point,roi_radius,n_dir,step_size,max_steps,fa_thresh);

if nargin < 4
    roi_radius = 15;
end
if nargin < 5
n_dir = 10000;
end
if nargin < 6
step_size = 1;
end
if nargin < 7
max_steps = 1000;
end
if nargin < 8
fa_thresh = 0.15;
end

nx = size(dti_directions,1);
ny = size(dti_directions,2);
nz = size(dti_directions,3);

dirs = generate_sphere_directions(n_dir,roi_radius);

dti_streamlines = cell(n_dir,1);

for k = 1:n_dir
    init_dir = dirs(k,:);
    stream  = trace_streamline(seed_point, dti_directions, dti_anisotropy, step_size, max_steps, fa_thresh, init_dir);
    dti_streamlines{k} = stream;
end

end

function dirs = generate_sphere_directions(N,roi_radius)
    dirs = zeros(N,3);
    phi = (1 + sqrt(5)) / 2;
    for k = 0:N-1
        z  = 1 - 2*(k + 0.5)/N;
        r  = sqrt(max(0, 1 - z^2));
        theta = 2*pi * k/phi;
        x = r * cos(theta);
        y = r * sin(theta);
        dirs(k+1,:) = roi_radius*[x, y, z];
    end
end

function xyz = trace_streamline(seed_point, dti_directions, dti_anisotropy, step_size, max_steps, fa_thresh, init_dir)
    [nx,ny,nz,~] = size(dti_directions);
    
    pos = double(seed_point(:)');
    xyz = zeros(max_steps, 3);
    xyz(1,:) = pos;
    
    d0 = init_dir(:)';
    
    pos = pos + d0;
    xyz(2,:) = pos;
    
    prev_dir = d0;
    k = 2;
    
    while k < max_steps
        ix = round(pos(1));
        iy = round(pos(2));
        iz = round(pos(3));
        
        if ix < 1 || ix > nx || iy < 1 || iy > ny || iz < 1 || iz > nz
            xyz = xyz(1:k,:);
            return;
        end
        
        v = squeeze(dti_directions(ix,iy,iz,:)).';
        fa = dti_anisotropy(ix,iy,iz);
        
        nrm = norm(v);
        if nrm == 0 || fa < fa_thresh
            xyz = xyz(1:k,:);
            return;
        end
        
        v = v / nrm;
        
        if dot(v, prev_dir) < 0
            v = -v;
        end
        prev_dir = v;
        
        pos = pos + step_size * v;
        k = k + 1;
        xyz(k,:) = pos;
    end
    
    xyz = xyz(1:k,:);

end
