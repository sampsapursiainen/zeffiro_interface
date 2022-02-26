    if not(evalin('base','zef.lock_transforms_on'))

zef_i = 1 + evalin('base',['length(zef.' zef.current_tag '_transform_name)']);

evalin('base',['zef.' zef.current_tag '_transform_name = [zef.' zef.current_tag '_transform_name, ''Transform ' num2str(zef_i) '''];']);
evalin('base',['zef.' zef.current_tag '_scaling = [zef.' zef.current_tag '_scaling, 1];']);
evalin('base',['zef.' zef.current_tag '_x_correction = [zef.' zef.current_tag '_x_correction, 0];']);
evalin('base',['zef.' zef.current_tag '_y_correction = [zef.' zef.current_tag '_y_correction, 0];']);
evalin('base',['zef.' zef.current_tag '_z_correction = [zef.' zef.current_tag '_z_correction, 0];']);
evalin('base',['zef.' zef.current_tag '_xy_rotation = [zef.' zef.current_tag '_xy_rotation, 0];']);
evalin('base',['zef.' zef.current_tag '_yz_rotation = [zef.' zef.current_tag '_yz_rotation, 0];']);
evalin('base',['zef.' zef.current_tag '_zx_rotation = [zef.' zef.current_tag '_zx_rotation, 0];']);

clear zef_i;

zef_init_transform;

    end