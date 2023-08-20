
function  zef_nse_plot_histogram(zef, plot_vec, x_label, legend_text)

if nargin < 4 
    legend_text = cell(0);
end

p = [0.8 0.5];
p_legend = {'IDR','IQR'};

alpha = 0.5;
legend_cell = cell(0);

h_axes = zef.h_axes1;
axes(h_axes);
hold off;
c_map = lines(size(plot_vec,2));
c_map = c_map + 0.1; 
c_map = c_map/max(c_map(:));

for i = 1:size(plot_vec,2)

    if isempty(legend_text)
    legend_cell{length(legend_cell)+1} = 'Full data';
    else
     legend_cell{length(legend_cell)+1} = legend_text{i};    
    end
    
    if size(plot_vec,2) > 1 
        legend_cell{i} = [legend_cell{length(legend_cell)} ' ' num2str(i)];
    end
    
    h_hist = histogram(h_axes, plot_vec(:,i));
    h_hist.FaceColor = c_map(i,:);
    h_hist.FaceAlpha = alpha; 
    h_hist.Normalization = 'probability';
    t = (1/2)*(h_hist.BinEdges(1:end-1) + h_hist.BinEdges(2:end));
    
    if i == 1
        hold on
    end
    
   for j = 1 : length(p)
   legend_cell{length(legend_cell)+1} = p_legend{j};
   q1=find(cumsum(h_hist.Values) >= (1-p(j))/2, 1, 'first');
   q2=find(cumsum(h_hist.Values) <= (1+p(j))/2, 1, 'last');
   h_bar =  bar(h_axes,t(q1:q2),h_hist.Values(q1:q2));
   h_bar.FaceAlpha = alpha;
    end
    
end

 pbaspect(h_axes, [1 1 1]);

legend(legend_cell,'Location','northwest');

hold off;

%h_axes.FontSize = 18;
h_axes.XGrid = 'on';
h_axes.YGrid = 'on';
ylabel('Probability');
xlabel(x_label);
h_axes.XLim = [min(h_hist.BinEdges) max(h_hist.BinEdges)];
h_axes.YLim = [0 1.05*max(h_hist.Values)];
set(h_axes,'FontSize',zef.font_size);

end
