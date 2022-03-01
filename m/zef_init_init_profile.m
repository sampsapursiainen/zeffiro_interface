for zef_i = 1 : size(zef.init_profile,1)

    if not(isstring(zef.init_profile{zef_i,2}))
        zef.init_profile{zef_i,2} = num2str(zef.init_profile{zef_i,2});
    end
<<<<<<< HEAD
    
    if isequal(zef.init_profile{zef_i,4},'string') 
    evalin('base',['zef.' zef.init_profile{zef_i,3} '= ''' zef.init_profile{zef_i,2}  ''';']); 
    elseif isequal(zef.init_profile{zef_i,4},'number') 
    evalin('base',['zef.' zef.init_profile{zef_i,3} '= ' zef.init_profile{zef_i,2}  ';']); 
    elseif isequal(zef.init_profile{zef_i,4},'evaluate') 
    evalin('base',zef.init_profile{zef_i,2}); 
=======

    if isequal(zef.init_profile{zef_i,4},'string')
    evalin('base',['zef.' zef.init_profile{zef_i,3} '= ''' zef.init_profile{zef_i,2}  ''';']);
    elseif isequal(zef.init_profile{zef_i,4},'number')
    evalin('base',['zef.' zef.init_profile{zef_i,3} '= ' zef.init_profile{zef_i,2}  ';']);
>>>>>>> 5b5c6faff4d84098629188095d4264ae682a8077
    end

end

clear zef_i;