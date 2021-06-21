function [lead_field_id,lead_field_id_max] = zef_update_lead_field_id(lead_field_id,lead_field_id_max,varargin)

lead_field_event = 'create';
if not(isempty(varargin))
lead_field_event = varargin{1};
end

if isequal(lead_field_event,'bank')
lead_field_id = lead_field_id;
lead_field_id_max = lead_field_id_max;
else
lead_field_id_max = lead_field_id_max + 1;
lead_field_id = lead_field_id_max;
end

end
