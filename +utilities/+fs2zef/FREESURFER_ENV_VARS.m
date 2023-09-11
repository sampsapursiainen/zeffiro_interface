function ENV_VARS = FREESURFER_ENV_VARS()
%
% FREESURFER_ENV_VARS
%
% A constant function, which returns a list of the environment variable names
% needed by FreeSurfer.
%
% Inputs:
%
% - None.
%
% Outputs:
%
% - ENV_VARS
%
%   The list of environment variable names.
%


    arguments end

    ENV_VARS = [
        "SUBJECTS_DIR" ;
        "FREESURFER" ;
        "FUNCTIONALS_DIR" ;
        "FSFAST_HOME" ;
        "MNI_DIR" ;
        "FSL_DIR" ;
        "FSF_OUTPUT_FORMAT" ;
        "LOCAL_DIR"
    ] ;

end % function
