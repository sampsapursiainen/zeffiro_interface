if evalin('base','zef.use_gpu')==1 && gpuDeviceCount > 0

gpuDevice(zef.gpu_num);

end
