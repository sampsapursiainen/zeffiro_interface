for zef_i = 1 : size(zef.init_profile,1)

    if not(isstring(zef.init_profile{zef_i,2}))
        zef.init_profile{zef_i,2} = num2str(zef.init_profile{zef_i,2});
    end

    if isequal(zef.init_profile{zef_i,4},'string')
        eval(['zef.' zef.init_profile{zef_i,3} '= ''' zef.init_profile{zef_i,2}  ''';']);
    elseif isequal(zef.init_profile{zef_i,4},'number')
        eval(['zef.' zef.init_profile{zef_i,3} '= ' zef.init_profile{zef_i,2}  ';']);
    elseif isequal(zef.init_profile{zef_i,4},'evaluate')
        eval(zef.init_profile{zef_i,2});
    end

end

clear zef_i;
