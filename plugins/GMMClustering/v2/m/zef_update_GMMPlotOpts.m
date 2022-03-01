%Copyright © 2018- Joonas Lahtinen, Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

%Update script for possibly hidden advanced plot options for GMM app.

zef_ind = find(strcmp(zef.GMM.parameters.Tags,'dip_num'));
if isempty(zef.GMM.parameters.Values{zef_ind})
    zef.GMM.parameters.Values{zef_ind} = zef.GMM.parameters.Values{1};
end

zef_ind = find(strcmp(zef.GMM.parameters.Tags,'ellip_num'));
if isempty(zef.GMM.parameters.Values{zef_ind})
    zef.GMM.parameters.Values{zef_ind} = zef.GMM.parameters.Values{1};
end

clear zef_ind
