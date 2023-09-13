function cleanup_obj = cleanup_via_fclose ( closable )
%
% cleanup_obj = cleanup_via_fclose ( closable )
%
% This function can be passed to an onCleanup object constructor to automate the closing of an
% object, whose class implements the fclose method.
%
% Inputs:
%
% - closable
%
%   An object that can be closed via the fclose method.
%
% Outputs:
%
% - cleanup_obj
%
%   A cleanup object, which will call an fclose method on the given closable object, once cleared
%   by MATLAB.
%

    arguments

        closable

    end

    cleanup_obj = onCleanup ( @() fclose ( closable ) ) ;

end
