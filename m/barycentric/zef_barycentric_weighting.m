function weighting = zef_barycentric_weighting(weighting_type)

switch weighting_type
   
    case 'CF'
        weighting = 1/6;
    case 'FF'
        weighting = [1/10 1/20];
    case 'GG'
        weighting = [1];
    case 'GF'
        weighting = [1/6];
end

end