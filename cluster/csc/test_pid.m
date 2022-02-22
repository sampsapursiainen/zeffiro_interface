function test_pid
spmd
    pid = feature('getpid');
    [~, core] = system(['ps -o psr -p ' num2str(pid) ' | tail -1']);
    core = str2num(deblank(core)); %#ok<ST2NM>
end
cores = sort([core{:}]) %#ok<NASGU,NOPRT>
