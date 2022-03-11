%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [c_1] = zef_import_asc(c_0,varargin)

c_1 = str2num(c_0);

n_varargin = length(varargin);
if n_varargin == 2
n_1 = varargin{1};
n_2 = varargin{2};
c_1 = c_1(:,n_1:n_2);
else
c_1 = c_1(:,1:3);
end

end
