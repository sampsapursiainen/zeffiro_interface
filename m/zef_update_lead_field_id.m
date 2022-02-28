function [lead_field_id,lead_field_id_max] = zef_update_lead_field_id(lead_field_id,lead_field_id_max,varargin)

lead_field_event = 'create'; %'' would be better, or lead_field_event instead of varargin
if not(isempty(varargin))
    lead_field_event = varargin{1};
end

switch lead_field_event

    case 'bank_replace'
        lead_field_id = lead_field_id;
        lead_field_id_max = lead_field_id_max;

    case 'bank_add'
        lead_field_id = lead_field_id;
        lead_field_id_max = lead_field_id_max;

    case 'bank_oldData'
        lead_field_id = lead_field_id;
        lead_field_id_max = lead_field_id_max+1;

    case 'bank_apply'
        lead_field_id = lead_field_id;
        lead_field_id_max = lead_field_id_max+1;

    case 'create'
        lead_field_id_max = lead_field_id_max + 1;
        lead_field_id = lead_field_id_max;

    otherwise
        error('event not specified');

end

end
