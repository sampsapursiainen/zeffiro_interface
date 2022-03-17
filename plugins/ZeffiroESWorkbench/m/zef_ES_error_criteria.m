function vec = zef_ES_error_criteria
%% Variables and parameters setup
    load_aux = evalin('base','zef.y_ES_interval');
B = cell2mat(load_aux.residual);
B = B/max(abs(B(:)));

E = cell2mat(load_aux.field_source.relative')';
F = cell2mat(load_aux.field_source.magnitude')';
G = cell2mat(load_aux.field_source.angle')';

A = zeros(size(load_aux.y_ES));
C = zeros(size(load_aux.y_ES));
D = zeros(size(load_aux.y_ES));

for i = 1:size(load_aux.y_ES,1)
    for j = 1:size(load_aux.y_ES,2)
        A(i,j) =         norm(cell2mat(load_aux.y_ES(i,j)),1);
        C(i,j) =          max(cell2mat(load_aux.y_ES(i,j)));
        D(i,j) = zef_ES_rwnnz(cell2mat(load_aux.y_ES(i,j)), evalin('base','zef.ES_relativeweightnnz'));
    end
end

X = {A,B,C,D,E,F,G};
vec = array2table(X,'VariableNames',{'Total Dose (L_{1}-Norm)', 'Residual', 'Max Y_{ES}', 'Effective NNZ Currents', 'Local Relative Error', 'Local Relative Magnitude Error', 'Local Orientation Error'});
end
