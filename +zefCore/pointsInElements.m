function TF = pointsInElements ( barycoords )
%
% TF = pointsInElements ( barycoords )
%
% When given a set of barycentric coordinates of a set of points, determines
% which points lie within which elements. This occurs when the barycentric
% coordinate of a point all lie in the interval [0,1].
%
% Inputs:
%
% - barycoords (:,:,:) double { mustBeFinite }
%
%   The 3D barycentric coordinates of each point, with barycoords(:,P,E) giving
%   us the barycentric coordinates of a point P with respect the element E.
%
% Outputs:
%
% - TF (1,:,:) logical
%
%   A 3D logical array that describes which points lie within which elements.
%   If TF (1,P,E) == true, then the point P is located within element E.
%

    arguments
        barycoords (:,:,:) double { mustBeFinite }
    end

    TF = all ( 0 <= barycoords & barycoords <= 1 , 1 ) ;

end % function
