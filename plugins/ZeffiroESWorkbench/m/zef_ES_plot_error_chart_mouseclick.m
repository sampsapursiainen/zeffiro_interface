clf()
axh = axes();
x = rand(1,20); y = rand(1,20); %z = rand(1,20);
h = plot(axh, x, y, 'ko');
xlabel('x axis'); ylabel('y axis'); %zlabel('z axis');
grid on
h.ButtonDownFcn = @showZValueFcn;

function [coordinateSelected, minIdx] = showZValueFcn(hObj, event)
[x,y] = deal(hObj.XData, hObj.YData);
pt = event.IntersectionPoint(1:2);
coordinates = [x(:),y(:)];
dist = pdist2(pt,coordinates);
[~, minIdx] = min(dist);
coordinateSelected = coordinates(minIdx,:);
fprintf('[x,y] = [%.5f, %.5f]\n', coordinateSelected)
end
