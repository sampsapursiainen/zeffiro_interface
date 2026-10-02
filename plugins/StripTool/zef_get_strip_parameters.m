function strip_struct = zef_get_strip_parameters(strip_struct)
%ZEF_GET_STRIP_PARAMETERS  Fill strip_radius and strip_n_contacts from strip_model.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   strip_struct = zef_get_strip_parameters(strip_struct)
%
%   Model 1: 4 contacts, 2: 8, 3: 40, each with radius 0.635. Models 4
%   and 5 are DiSC probes (radius 0.400, 64 and 128 contacts). Called from
%   zef_create_strip / embed / add_contacts. Does not write zef.
%
%   See also zef_create_strip.

if isequal(strip_struct.strip_model,1)
strip_struct.strip_radius = 0.635;
strip_struct.strip_n_contacts = 4;
elseif isequal(strip_struct.strip_model,2)
strip_struct.strip_radius = 0.635;
strip_struct.strip_n_contacts = 8;
elseif isequal(strip_struct.strip_model,3)
strip_struct.strip_radius = 0.635;
strip_struct.strip_n_contacts = 40;
% DiSC directional depth array (models 4 and 5): shaft radius 0.400 mm,
% 64 or 128 contacts. Resolving the 0.120 mm patches needs a
% circumferential edge below about 0.040 mm (n_sectors at least 63). A
% long shaft at that density makes the cylinder Delaunay expensive.
elseif isequal(strip_struct.strip_model,4)
strip_struct.strip_radius = 0.400;
strip_struct.strip_n_contacts = 64;
elseif isequal(strip_struct.strip_model,5)
strip_struct.strip_radius = 0.400;
strip_struct.strip_n_contacts = 128;
end

end
