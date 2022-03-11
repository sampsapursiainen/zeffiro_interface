function [d] = zef_determinant(a,b,c,varargin)

det_dir = 2;
if not(isempty(varargin))
    det_dir = varargin{1};
end

if det_dir == 1;
d = a(1,:).*(b(2,:).*c(3,:) - c(2,:).*b(3,:)) - b(1,:).*(a(2,:).*c(3,:) - c(2,:).*a(3,:)) +  c(1,:).*(a(2,:).*b(3,:) - b(2,:).*a(3,:));
else
d = a(:,1).*(b(:,2).*c(:,3) - c(:,2).*b(:,3)) - b(:,1).*(a(:,2).*c(:,3) - c(:,2).*a(:,3)) +  c(:,1).*(a(:,2).*b(:,3) - b(:,2).*a(:,3));
end

end
