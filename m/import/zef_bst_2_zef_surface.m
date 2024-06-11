function [vertices, faces, surface_data, surface] = zef_bst_2_zef_surface(varargin)

surface_data = struct;
surface_ind_aux = [];
vertices = [];
faces = [];
surface = [];
subject = [];
surface_properties = [];
scaling_constant = 1000;

if not(isempty(varargin))
    subject = varargin{1};
    if length(varargin)>1
        surface_ind_aux = varargin{2};
    end
    if length(varargin)>2
        surface_properties = varargin{3};
        if not(iscell(surface_properties))
            surface_properties = {surface_properties};
        end
    end
end

if isempty(subject)
    surface = bst_get('ProtocolSubjects').Subject.Surface;
    surface_file = [];
elseif isempty(surface_ind_aux)
    surface = bst_get('ProtocolSubjects').Subject(subject).Surface;
    surface_file = [];
else
    surface = bst_get('ProtocolSubjects').Subject(subject).Surface;
    surface_file = [ bst_get('ProtocolInfo').SUBJECTS filesep bst_get('ProtocolSubjects').Subject(subject).Surface(surface_ind_aux).FileName];
end

if not(isempty(surface_file))

    if not(isempty(surface_properties))
        surface_data = load(surface_file,surface_properties{:});
        if isequal(length(surface_properties),1)
            surface_data = surface_data.(surface_properties{:});
        end
    else
        surface_data = load(surface_file);
    end

    if isfield(surface_data,'Vertices')
        vertices = scaling_constant*surface_data.Vertices;
    end

    if isfield(surface_data,'Faces')
        faces = surface_data.Faces;
    end


end


end
