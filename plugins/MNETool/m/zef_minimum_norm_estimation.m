%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface


function zef = zef_minimum_norm_estimation(zef)

if nargin == 0
zef = evalin('base','zef');
end    

zef = zef_tool_start(zef,'zef_mne_tool_start',1/4,0);

if nargout == 0
    assignin('base','zef',zef)
end

end

