function cleanup_obj = cleanup_via_close ( closable )
%
% cleanup_obj = cleanup_via_close ( closable )
%
% This function can be passed to an onCleanup object constructor to automate the closing of an
% object, whose class implements the close method.
%
% Inputs:
%
% - closable
%
%   An object that can be closed via the close method.
%
% Outputs:
%
% - cleanup_obj
%
%   A cleanup object, which will call a close method on the given closable object, once cleared by
%   MATLAB.
%

    arguments

        closable

    end

    cleanup_obj = onCleanup ( @() close ( closable ) ) ;

end
