%Update script for possibly hidden advanced plot options for GMM app.

if isempty(zef.GMM.parameters.Values{20})
    zef.GMM.parameters.Values{20} = zef.GMM.parameters.Values{1};
end

if isempty(zef.GMM.parameters.Values{21})
    zef.GMM.parameters.Values{21} = zef.GMM.parameters.Values{1};
end