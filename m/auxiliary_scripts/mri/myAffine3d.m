function [point] = myAffine3d(point, matrix)
%point(s) Nx3, matrix 4x4 affine matrix,
%output is the transformed point(s)

[N, ~]=size(point);

point=point';
point=vertcat(point, ones(1,N));

point=matrix*point;

point=point(1:3,:);

point=point';

end

