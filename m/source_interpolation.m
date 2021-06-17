Last login: Thu Jun 17 09:14:53 on ttys004

The default interactive shell is now zsh.
To update your account to use zsh, please run `chsh -s /bin/zsh`.
For more details, please visit https://support.apple.com/kb/HT208050.
wks-95038-mac:~ pursiain$ ssh -L 5910:localhost:5910 sampsa@mat-herique.rd.tut.fi
sampsa@mat-herique.rd.tut.fi's password: 
bind [127.0.0.1]:5910: Address already in use
channel_setup_fwd_listener_tcpip: cannot listen to port: 5910
Could not request local forwarding.
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.8.0-44-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

309 updates can be installed immediately.
165 of these updates are security updates.
To see these additional updates run: apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Thu Jun 17 15:23:07 2021 from 85.76.51.40
sampsa@herique:~$ logout
Connection to mat-herique.rd.tut.fi closed.
wks-95038-mac:~ pursiain$ ssh -L 5910:localhost:5910 sampsa@mat-herique.rd.tut.fi
sampsa@mat-herique.rd.tut.fi's password: 
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.8.0-44-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

309 updates can be installed immediately.
165 of these updates are security updates.
To see these additional updates run: apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Thu Jun 17 15:47:24 2021 from 85.76.51.40
sampsa@herique:~$ nvidia-smi
Thu Jun 17 15:50:50 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1289MiB /  7979MiB |      1%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        8MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:~$ nvidia-smi -l
Thu Jun 17 15:50:52 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1289MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        8MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:50:57 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1289MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        8MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:51:02 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1289MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        8MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:51:07 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1289MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        8MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:51:12 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1287MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        6MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:51:17 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1288MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        6MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:51:22 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1288MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        6MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:51:27 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1288MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        7MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:51:32 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1288MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        7MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:51:37 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1288MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        7MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:51:42 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1288MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        7MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:51:47 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1289MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        7MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:51:52 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1289MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        7MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:51:57 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1289MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        8MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:52:02 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   38C    P8    12W / 125W |   1289MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        8MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:52:07 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1289MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        8MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:52:12 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1289MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        8MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:52:17 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   38C    P8    12W / 125W |   1287MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        6MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:52:22 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1288MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        6MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:52:27 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1288MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        6MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:52:32 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1288MiB /  7979MiB |      1%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        7MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:52:37 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1288MiB /  7979MiB |      1%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        7MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:52:43 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   38C    P8    12W / 125W |   1288MiB /  7979MiB |      1%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        7MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:52:48 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   38C    P8    12W / 125W |   1288MiB /  7979MiB |      1%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        7MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:52:53 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1289MiB /  7979MiB |      1%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        7MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:52:58 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   38C    P8    12W / 125W |   1289MiB /  7979MiB |      1%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        7MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:53:03 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   38C    P8    12W / 125W |   1289MiB /  7979MiB |      1%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        8MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:53:08 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8    12W / 125W |   1289MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        8MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 15:53:13 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   38C    P8    12W / 125W |   1289MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                468MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        8MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
^Csampsa@herique:~$ matlab -nodesktop
MATLAB is selecting SOFTWARE OPENGL rendering.

                                         < M A T L A B (R) >
                               Copyright 1984-2020 The MathWorks, Inc.
                          R2020b Update 1 (9.9.0.1495850) 64-bit (glnxa64)
                                         September 30, 2020

 
To get started, type doc.
For product information, visit www.mathworks.com.
 
>> gpuDeviceCount

ans =

     0

>> gpuDevice     
Error using gpuDevice (line 26)
Unable to find a supported GPU device. For more information on GPU support, see <a
href="matlab:web('http://www.mathworks.com/help/parallel-computing/gpu-support-by-release.html','-browser')">GPU
Support by Release</a>.
 
>> quit     
sampsa@herique:~$ top

top - 15:57:13 up 55 days, 21:15,  5 users,  load average: 5,98, 5,97, 4,48
Tasks: 854 total,   1 running, 853 sleeping,   0 stopped,   0 zombie
%Cpu(s):  7,0 us,  2,1 sy,  0,0 ni, 90,9 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total,   8424,7 free, 110405,4 used,   9714,5 buff/cache
MiB Swap:   2048,0 total,    906,2 free,   1141,8 used.  16147,5 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                          
1214947 joonasl+  20   0   69,7g  56,8g 457064 S  94,4  45,3 347:19.89 MATLAB                           
1241115 sampsa    20   0   17416   5188   3520 R  11,1   0,0   0:00.14 top                              
 593840 alexand+  20   0   25,3g   3,0g 120044 S   5,6   2,4 222:38.03 MATLAB                           
 595006 alexand+  20   0 2713092 181532  32076 S   5,6   0,1 248:49.42 cef_helper                       
 852311 atena     20   0 4434292 600728 187788 S   5,6   0,5 195:54.96 firefox                          
 852435 atena     20   0 3317552 585140 163644 S   5,6   0,4  68:27.18 Web Content                      
 852525 atena     20   0 4332304 859312 111636 S   5,6   0,7 240:35.81 Web Content                      
 906677 atena     20   0 5341600  11448   7180 S   5,6   0,0 172:42.72 pulseaudio                       
1199086 frank     20   0 2376448 214344  60684 S   5,6   0,2  10:46.17 cef_helper                       
1199864 frank     20   0 2372852 204976  76156 S   5,6   0,2   1:06.00 MATLABWindow                     
1237112 sampsa    20   0 2406064 206836  60308 S   5,6   0,2   0:17.96 cef_helper                       
1237705 sampsa    20   0 2347516 141604  59696 S   5,6   0,1   0:03.51 MATLABWindow                     
1506324 frank     20   0  247600  75900  30132 S   5,6   0,1 249:46.36 Xtightvnc                        
2063832 sampsa    20   0  845672  28828  16700 S   5,6   0,0  11:13.72 gnome-panel                      
2064035 sampsa    20   0  843956  22832  11568 S   5,6   0,0  11:11.16 gnome-panel                      
      1 root      20   0  170980  10892   4868 S   0,0   0,0   6:52.29 systemd                          
      2 root      20   0       0      0      0 S   0,0   0,0   0:02.96 kthreadd                         
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                           
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                       
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd             
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                     
     10 root      20   0       0      0      0 S   0,0   0,0   2:00.37 ksoftirqd/0                      
     11 root      20   0       0      0      0 I   0,0   0,0 143:37.53 rcu_sched                        
     12 root      rt   0       0      0      0 S   0,0   0,0  14:46.04 migration/0                      
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                    
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                          
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                          
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                    
     17 root      rt   0       0      0      0 S   0,0   0,0   0:15.34 migration/1                      
     18 root      20   0       0      0      0 S   0,0   0,0   0:39.63 ksoftirqd/1                      
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd             
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                          
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                    
     23 root      rt   0       0      0      0 S   0,0   0,0  18:11.39 migration/2                      
     24 root      20   0       0      0      0 S   0,0   0,0   0:14.48 ksoftirqd/2                      
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd             
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                          
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                    
     29 root      rt   0       0      0      0 S   0,0   0,0  20:36.72 migration/3                      
     30 root      20   0       0      0      0 S   0,0   0,0   0:09.08 ksoftirqd/3                      
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd             
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                          
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                    
     35 root      rt   0       0      0      0 S   0,0   0,0  23:55.81 migration/4                      
     36 root      20   0       0      0      0 S   0,0   0,0   0:05.09 ksoftirqd/4                      
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd             
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                          
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                    
     41 root      rt   0       0      0      0 S   0,0   0,0  29:45.27 migration/5                      
     42 root      20   0       0      0      0 S   0,0   0,0   0:06.18 ksoftirqd/5                      
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd             
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                          
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                    
     47 root      rt   0       0      0      0 S   0,0   0,0   7:41.19 migration/6                      
     48 root      20   0       0      0      0 S   0,0   0,0   0:20.95 ksoftirqd/6                      
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd             
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                          
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                    
     53 root      rt   0       0      0      0 S   0,0   0,0   9:20.64 migration/7                      
     54 root      20   0       0      0      0 S   0,0   0,0   0:10.83 ksoftirqd/7                      
     56 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/7:0H-kblockd             
     57 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/8                          
     58 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/8                    
     59 root      rt   0       0      0      0 S   0,0   0,0   0:14.36 migration/8                      
     60 root      20   0       0      0      0 S   0,0   0,0   0:15.62 ksoftirqd/8                      
     62 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/8:0H-kblockd             
     63 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/9                          
     64 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/9                    
     65 root      rt   0       0      0      0 S   0,0   0,0  28:34.66 migration/9                      
     66 root      20   0       0      0      0 S   0,0   0,0   0:08.60 ksoftirqd/9                      
     68 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/9:0H-kblockd             
     69 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/10                         
     70 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/10                   
     71 root      rt   0       0      0      0 S   0,0   0,0  21:21.74 migration/10                     
     72 root      20   0       0      0      0 S   0,0   0,0   0:02.32 ksoftirqd/10                     
     74 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/10:0H-kblockd            
     75 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/11                         
     76 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/11                   
     77 root      rt   0       0      0      0 S   0,0   0,0  15:29.53 migration/11                     
     78 root      20   0       0      0      0 S   0,0   0,0   0:12.35 ksoftirqd/11                     
     80 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/11:0H-kblockd            
     81 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/12                         
sampsa@herique:~$ matlab -nodesktop
MATLAB is selecting SOFTWARE OPENGL rendering.

                                         < M A T L A B (R) >
                               Copyright 1984-2020 The MathWorks, Inc.
                          R2020b Update 1 (9.9.0.1495850) 64-bit (glnxa64)
                                         September 30, 2020

 
To get started, type doc.
For product information, visit www.mathworks.com.
 
>> gpuDeviceCount

ans =

     0

>> quit
sampsa@herique:~$ nvidia-smi
Thu Jun 17 16:04:23 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    340MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   38C    P8    12W / 125W |   1253MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    593840      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                434MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       21MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              276MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A   1094725      G   ...R2020b/bin/glnxa64/MATLAB      206MiB |
|    1   N/A  N/A   1096547      G   ...37E28E528C21E8599F34EC698        6MiB |
|    1   N/A  N/A   1114689      G   ...D028C84210FE4E344811086F9       65MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:~$ kill 593840
-bash: kill: (593840) - Operation not permitted
sampsa@herique:~$ sudo kill 593840
[sudo] password for sampsa: 
sampsa@herique:~$ sudo kill 1094725
sampsa@herique:~$ nvidia-smi
Thu Jun 17 16:05:28 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    111MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   38C    P8    12W / 125W |    953MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    976966      C   ...ffice/program/soffice.bin       97MiB |
|    1   N/A  N/A      1332      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    834576      G   /usr/lib/xorg/Xorg                425MiB |
|    1   N/A  N/A    835274      G   ...gAAAAAAAAA --shared-files       22MiB |
|    1   N/A  N/A    835591      G   ...AAAAAAAA== --shared-files       72MiB |
|    1   N/A  N/A    852435      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    852525      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    852560      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    874716      G   /usr/lib/firefox/firefox           39MiB |
|    1   N/A  N/A    922240      G   /usr/bin/gnome-shell              264MiB |
|    1   N/A  N/A    971632      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    975158      G   /usr/lib/firefox/firefox            3MiB |
|    1   N/A  N/A    979664      G   /usr/lib/firefox/firefox            3MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:~$ matlab -nodesktop
MATLAB is selecting SOFTWARE OPENGL rendering.

                                         < M A T L A B (R) >
                               Copyright 1984-2020 The MathWorks, Inc.
                          R2020b Update 1 (9.9.0.1495850) 64-bit (glnxa64)
                                         September 30, 2020

 
To get started, type doc.
For product information, visit www.mathworks.com.
 
>> gpuDeviceCount               

ans =

     0

>> quit
sampsa@herique:~$ sudo reboot
sampsa@herique:~$ Connection to mat-herique.rd.tut.fi closed by remote host.
Connection to mat-herique.rd.tut.fi closed.
wks-95038-mac:~ pursiain$ ssh -L 5910:localhost:5910 sampsa@mat-herique.rd.tut.fi
^C
wks-95038-mac:~ pursiain$ ssh -L 5910:localhost:5910 sampsa@mat-herique.rd.tut.fi
sampsa@mat-herique.rd.tut.fi's password: 
channel 3: open failed: connect failed: Connection refused
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.8.0-44-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

309 updates can be installed immediately.
165 of these updates are security updates.
To see these additional updates run: apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Thu Jun 17 15:47:57 2021 from 85.76.51.40
sampsa@herique:~$ channel 3: open failed: connect failed: Connection refused
channel 3: open failed: connect failed: Connection refused
channel 3: open failed: connect failed: Connection refused

sampsa@herique:~$ channel 3: open failed: connect failed: Connection refused
channel 3: open failed: connect failed: Connection refused
channel 3: open failed: connect failed: Connection refused
channel 3: open failed: connect failed: Connection refused
vchannel 3: open failed: connect failed: Connection refused
ncserchannel 3: open failed: connect failed: Connection refused
ver -gechannel 3: open failed: connect failed: Connection refused
ometrychannel 3: open failed: connect failed: Connection refused
 1920xchannel 3: open failed: connect failed: Connection refused
1080 channel 3: open failed: connect failed: Connection refused
:10
Found /usr/share/tightvnc-java for http connections.

New 'X' desktop is herique:10

Starting applications specified in /home/sampsa/.vnc/xstartup
Log file is /home/sampsa/.vnc/herique:10.log

sampsa@herique:~$ 
  [Restored 17. Jun 2021 at 16.13.48]
Last login: Thu Jun 17 16:13:35 on console

The default interactive shell is now zsh.
To update your account to use zsh, please run `chsh -s /bin/zsh`.
For more details, please visit https://support.apple.com/kb/HT208050.
wks-95038-mac:~ pursiain$ ssh sampsa@mat-herique.rd.tut.fi
sampsa@mat-herique.rd.tut.fi's password: 
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.8.0-44-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

309 updates can be installed immediately.
165 of these updates are security updates.
To see these additional updates run: apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Thu Jun 17 16:09:34 2021 from 85.76.51.40
sampsa@herique:~$ top

top - 17:06:27 up 57 min,  1 user,  load average: 0,06, 0,12, 0,14
Tasks: 479 total,   1 running, 478 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,3 us,  0,2 sy,  0,0 ni, 99,6 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 121634,1 free,   4743,3 used,   2167,2 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 122576,8 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                          
   3510 sampsa    20   0 2580720 209884  59744 S   3,3   0,2   1:51.50 cef_helper                       
   5954 joonasl+  20   0 2374680 208648  60300 S   3,3   0,2   1:26.08 cef_helper                       
   2305 sampsa    20   0   22,4g   1,4g 412296 S   2,6   1,1   2:23.50 MATLAB                           
   4785 joonasl+  20   0   24,3g   2,5g 636096 S   2,6   2,0   3:14.87 MATLAB                           
    137 root      20   0       0      0      0 I   0,3   0,0   0:00.16 kworker/1:2-events               
   4365 joonasl+  20   0  230328 107248  57980 S   0,3   0,1   0:16.70 Xtightvnc                        
      1 root      20   0  167996  11744   8304 S   0,0   0,0   0:01.95 systemd                          
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.00 kthreadd                         
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                           
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                       
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd             
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                     
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/0                      
     11 root      20   0       0      0      0 I   0,0   0,0   0:05.13 rcu_sched                        
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.04 migration/0                      
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                    
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                          
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                          
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                    
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.60 migration/1                      
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/1                      
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd             
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                          
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                    
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.67 migration/2                      
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/2                      
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd             
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                          
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                    
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.65 migration/3                      
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/3                      
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd             
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                          
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                    
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.66 migration/4                      
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                      
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd             
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                          
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                    
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.68 migration/5                      
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                      
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd             
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                          
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                    
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.68 migration/6                      
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/6                      
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd             
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                          
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                    
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.68 migration/7                      
sampsa@herique:~$ nvidia-smi
Thu Jun 17 17:06:36 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   30C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   31C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:~$ top

top - 17:06:51 up 57 min,  1 user,  load average: 0,04, 0,11, 0,13
Tasks: 481 total,   1 running, 480 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,8 us,  0,6 sy,  0,0 ni, 98,6 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 121629,3 free,   4745,8 used,   2169,5 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 122574,2 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                          
   3510 sampsa    20   0 2580720 209884  59744 S   6,2   0,2   1:52.25 cef_helper                       
   8696 sampsa    20   0   16868   4516   3416 R   6,2   0,0   0:00.02 top                              
      1 root      20   0  167996  11744   8304 S   0,0   0,0   0:01.95 systemd                          
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.00 kthreadd                         
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                           
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                       
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd             
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                     
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/0                      
     11 root      20   0       0      0      0 I   0,0   0,0   0:05.17 rcu_sched                        
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.04 migration/0                      
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                    
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                          
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                          
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                    
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.60 migration/1                      
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/1                      
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd             
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                          
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                    
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.67 migration/2                      
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/2                      
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd             
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                          
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                    
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.65 migration/3                      
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/3                      
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd             
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                          
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                    
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.66 migration/4                      
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                      
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd             
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                          
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                    
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.68 migration/5                      
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                      
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd             
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                          
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                    
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.68 migration/6                      
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/6                      
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd             
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                          
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                    
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.68 migration/7                      
     54 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/7                      
     55 root      20   0       0      0      0 I   0,0   0,0   0:00.16 kworker/7:0-events               
     56 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/7:0H-kblockd             
     57 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/8                          
sampsa@herique:~$ logout
Connection to mat-herique.rd.tut.fi closed.
wks-95038-mac:~ pursiain$ ssh sampsa@mat-shannon.rd.tut.fi
sampsa@mat-shannon.rd.tut.fi's password: 
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-56-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

427 updates can be installed immediately.
192 of these updates are security updates.
To see these additional updates run: apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Thu Jun 17 15:08:11 2021 from 85.76.51.40
sampsa@shannon:~$ top

top - 17:07:11 up 129 days,  2:06,  5 users,  load average: 4,44, 3,81, 4,18
Tasks: 1028 total,   1 running, 1027 sleeping,   0 stopped,   0 zombie
%Cpu(s): 17,8 us,  0,4 sy,  0,0 ni, 81,2 id,  0,0 wa,  0,0 hi,  0,6 si,  0,0 st
MiB Mem : 257473,2 total,  11326,6 free, 147656,7 used,  98489,8 buff/cache
MiB Swap:   2048,0 total,    110,8 free,   1937,2 used. 106855,4 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                          
2241338 liisaida  20   0   42,8g   8,6g 546064 S 127,1   3,4   2204:03 MATLAB                           
2240669 liisaida  20   0   43,1g   8,8g 543384 S 124,1   3,5   2159:40 MATLAB                           
2353045 sampsa    20   0   93,2g  72,1g 662228 S 100,0  28,7 296:03.73 MATLAB                           
1977990 yusuf     20   0 3707976 996,9m  73988 S   1,7   0,4   1184:32 Web Content                      
1001069 yusuf     20   0 2905688   6776   4264 S   1,3   0,0 513:03.28 pulseaudio                       
1977722 yusuf     20   0 4107944 457104 138212 S   1,3   0,2 815:00.94 firefox                          
2365982 sampsa    20   0   17516   5280   3496 R   1,0   0,0   0:00.07 top                              
3201740 sampsa    20   0 6010308 380316  89772 S   1,0   0,1  63:41.06 gnome-shell                      
   1527 gdm       20   0 3998132  61624  31716 S   0,7   0,0  98:40.79 gnome-shell                      
 612473 yusuf     20   0   28,6g   4,3g 663036 S   0,7   1,7 425:29.51 MATLAB                           
2199171 sampsa    20   0   39,8g  15,9g 791612 S   0,7   6,3 435:34.08 MATLAB                           
2328756 liisaida  20   0   15692   4880   3300 S   0,7   0,0   4:00.37 top                              
     11 root      20   0       0      0      0 I   0,3   0,0 384:28.25 rcu_sched                        
   1106 root      20   0  406168  22728   6560 S   0,3   0,0 165:02.53 f2b/server                       
   1452 root     -51   0       0      0      0 S   0,3   0,0  84:51.14 irq/83-nvidia                    
   1454 root      20   0       0      0      0 S   0,3   0,0 124:26.12 nv_queue                         
 383722 astrid    20   0 3257700 311636 113164 S   0,3   0,1  82:32.26 firefox                          
 383968 astrid    20   0 2631176 211888  97844 S   0,3   0,1 155:44.69 Web Content                      
 386058 astrid    20   0   14,7g   1,6g 407476 S   0,3   0,6 159:33.83 MATLAB                           
1384909 sampsa    20   0   29,7g   5,3g 717852 S   0,3   2,1  22814:05 MATLAB                           
1385570 sampsa    20   0   34,5g   8,4g 736680 S   0,3   3,4  23963:23 MATLAB                           
1619790 yusuf     20   0  314868 129616  89604 S   0,3   0,0 514:00.65 Xtightvnc                        
1977790 yusuf     20   0 2558492 162264  68800 S   0,3   0,1  24:16.97 Privileged Cont                  
1977800 yusuf     20   0 2551084  42108  25504 S   0,3   0,0  58:59.38 WebExtensions                    
2030569 yusuf     20   0   18,1g   3,4g 478376 S   0,3   1,4  97:00.90 MATLAB                           
2080354 sampsa    20   0 1765220 595940  78244 S   0,3   0,2 110:26.83 teams-for-linux                  
2223312 sampsa    20   0 3020640 229064  75340 S   0,3   0,1   8:25.17 MATLABWindow                     
2226857 frank     20   0 2537980 278008  72304 S   0,3   0,1   4:13.87 MATLABWindow                     
2226884 frank     20   0 3092100 240084  60228 S   0,3   0,1   4:36.99 MATLABWindow                     
2226908 frank     20   0 3093984 238040  59324 S   0,3   0,1   4:37.40 MATLABWindow                     
2230891 frank     20   0  319588   8876   7856 S   0,3   0,0   0:02.79 gvfs-afc-volume                  
2269761 sampsa    20   0 2399916 152624  61244 S   0,3   0,1   2:57.35 MATLABWindow                     
2269789 sampsa    20   0 2407752 165396  60168 S   0,3   0,1   3:04.51 MATLABWindow                     
2561550 yusuf     20   0 2653352 233128  66424 S   0,3   0,1 161:09.41 Web Content                      
      1 root      20   0  169880   9788   4932 S   0,0   0,0  18:18.46 systemd                          
      2 root      20   0       0      0      0 S   0,0   0,0   0:07.47 kthreadd                         
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                           
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                       
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd             
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                     
     10 root      20   0       0      0      0 S   0,0   0,0   2:54.48 ksoftirqd/0                      
     12 root      rt   0       0      0      0 S   0,0   0,0   0:33.65 migration/0                      
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                    
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                          
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                          
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                    
     17 root      rt   0       0      0      0 S   0,0   0,0   8:17.58 migration/1                      
     18 root      20   0       0      0      0 S   0,0   0,0   1:43.35 ksoftirqd/1                      
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd             
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                          
sampsa@shannon:~$ nvidia-smi -l
Thu Jun 17 17:07:15 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 455.38       Driver Version: 455.38       CUDA Version: 11.1     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 8000     Off  | 00000000:17:00.0 Off |                  Off |
| 60%   79C    P2   264W / 260W |  33525MiB / 48601MiB |    100%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 8000     Off  | 00000000:65:00.0 Off |                  Off |
| 33%   49C    P8    24W / 260W |   2732MiB / 48598MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB      313MiB |
|    0   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   2080100      G   ...oken=13985188176333450559        0MiB |
|    0   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB      539MiB |
|    0   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB     6249MiB |
|    0   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB    12301MiB |
|    0   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB    12237MiB |
|    0   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB     2047MiB |
|    0   N/A  N/A   2354166      G   gnome-control-center                0MiB |
|    0   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A   3201740      G   /usr/bin/gnome-shell                0MiB |
|    1   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB      373MiB |
|    1   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB     1995MiB |
|    1   N/A  N/A   2080100      G   ...oken=13985188176333450559       75MiB |
|    1   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2354166      G   gnome-control-center               39MiB |
|    1   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                156MiB |
|    1   N/A  N/A   3201740      G   /usr/bin/gnome-shell               21MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:07:20 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 455.38       Driver Version: 455.38       CUDA Version: 11.1     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 8000     Off  | 00000000:17:00.0 Off |                  Off |
| 60%   79C    P2   257W / 260W |  33525MiB / 48601MiB |    100%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 8000     Off  | 00000000:65:00.0 Off |                  Off |
| 33%   49C    P8    24W / 260W |   2732MiB / 48598MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB      313MiB |
|    0   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   2080100      G   ...oken=13985188176333450559        0MiB |
|    0   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB      539MiB |
|    0   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB     6249MiB |
|    0   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB    12301MiB |
|    0   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB    12061MiB |
|    0   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB     2047MiB |
|    0   N/A  N/A   2354166      G   gnome-control-center                0MiB |
|    0   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A   3201740      G   /usr/bin/gnome-shell                0MiB |
|    1   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB      373MiB |
|    1   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB     1995MiB |
|    1   N/A  N/A   2080100      G   ...oken=13985188176333450559       75MiB |
|    1   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2354166      G   gnome-control-center               39MiB |
|    1   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                156MiB |
|    1   N/A  N/A   3201740      G   /usr/bin/gnome-shell               21MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:07:26 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 455.38       Driver Version: 455.38       CUDA Version: 11.1     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 8000     Off  | 00000000:17:00.0 Off |                  Off |
| 60%   79C    P2   258W / 260W |  33701MiB / 48601MiB |    100%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 8000     Off  | 00000000:65:00.0 Off |                  Off |
| 33%   49C    P8    24W / 260W |   2732MiB / 48598MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB      313MiB |
|    0   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   2080100      G   ...oken=13985188176333450559        0MiB |
|    0   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB      539MiB |
|    0   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB     6249MiB |
|    0   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB    12301MiB |
|    0   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB    12237MiB |
|    0   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB     2047MiB |
|    0   N/A  N/A   2354166      G   gnome-control-center                0MiB |
|    0   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A   3201740      G   /usr/bin/gnome-shell                0MiB |
|    1   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB      373MiB |
|    1   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB     1995MiB |
|    1   N/A  N/A   2080100      G   ...oken=13985188176333450559       75MiB |
|    1   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2354166      G   gnome-control-center               39MiB |
|    1   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                156MiB |
|    1   N/A  N/A   3201740      G   /usr/bin/gnome-shell               21MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:07:31 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 455.38       Driver Version: 455.38       CUDA Version: 11.1     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 8000     Off  | 00000000:17:00.0 Off |                  Off |
| 60%   79C    P2   250W / 260W |  33701MiB / 48601MiB |    100%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 8000     Off  | 00000000:65:00.0 Off |                  Off |
| 33%   49C    P8    24W / 260W |   2732MiB / 48598MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB      313MiB |
|    0   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   2080100      G   ...oken=13985188176333450559        0MiB |
|    0   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB      539MiB |
|    0   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB     6249MiB |
|    0   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB    12477MiB |
|    0   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB    12061MiB |
|    0   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB     2047MiB |
|    0   N/A  N/A   2354166      G   gnome-control-center                0MiB |
|    0   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A   3201740      G   /usr/bin/gnome-shell                0MiB |
|    1   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB      373MiB |
|    1   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB     1995MiB |
|    1   N/A  N/A   2080100      G   ...oken=13985188176333450559       75MiB |
|    1   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2354166      G   gnome-control-center               39MiB |
|    1   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                156MiB |
|    1   N/A  N/A   3201740      G   /usr/bin/gnome-shell               21MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:07:36 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 455.38       Driver Version: 455.38       CUDA Version: 11.1     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 8000     Off  | 00000000:17:00.0 Off |                  Off |
| 60%   79C    P2   263W / 260W |  33525MiB / 48601MiB |    100%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 8000     Off  | 00000000:65:00.0 Off |                  Off |
| 33%   49C    P8    24W / 260W |   2732MiB / 48598MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB      313MiB |
|    0   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   2080100      G   ...oken=13985188176333450559        0MiB |
|    0   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB      539MiB |
|    0   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB     6249MiB |
|    0   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB    12301MiB |
|    0   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB    12061MiB |
|    0   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB     2047MiB |
|    0   N/A  N/A   2354166      G   gnome-control-center                0MiB |
|    0   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A   3201740      G   /usr/bin/gnome-shell                0MiB |
|    1   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB      373MiB |
|    1   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB     1995MiB |
|    1   N/A  N/A   2080100      G   ...oken=13985188176333450559       75MiB |
|    1   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2354166      G   gnome-control-center               39MiB |
|    1   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                156MiB |
|    1   N/A  N/A   3201740      G   /usr/bin/gnome-shell               21MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:07:41 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 455.38       Driver Version: 455.38       CUDA Version: 11.1     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 8000     Off  | 00000000:17:00.0 Off |                  Off |
| 60%   79C    P2   256W / 260W |  33525MiB / 48601MiB |    100%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 8000     Off  | 00000000:65:00.0 Off |                  Off |
| 33%   49C    P8    24W / 260W |   2732MiB / 48598MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB      313MiB |
|    0   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   2080100      G   ...oken=13985188176333450559        0MiB |
|    0   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB      539MiB |
|    0   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB     6249MiB |
|    0   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB    12301MiB |
|    0   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB    12237MiB |
|    0   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB     2047MiB |
|    0   N/A  N/A   2354166      G   gnome-control-center                0MiB |
|    0   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A   3201740      G   /usr/bin/gnome-shell                0MiB |
|    1   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB      373MiB |
|    1   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB     1995MiB |
|    1   N/A  N/A   2080100      G   ...oken=13985188176333450559       75MiB |
|    1   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2354166      G   gnome-control-center               39MiB |
|    1   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                156MiB |
|    1   N/A  N/A   3201740      G   /usr/bin/gnome-shell               21MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:07:46 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 455.38       Driver Version: 455.38       CUDA Version: 11.1     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 8000     Off  | 00000000:17:00.0 Off |                  Off |
| 60%   79C    P2   258W / 260W |  33525MiB / 48601MiB |    100%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 8000     Off  | 00000000:65:00.0 Off |                  Off |
| 33%   49C    P8    24W / 260W |   2732MiB / 48598MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB      313MiB |
|    0   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   2080100      G   ...oken=13985188176333450559        0MiB |
|    0   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB      539MiB |
|    0   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB     6249MiB |
|    0   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB    12301MiB |
|    0   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB    12061MiB |
|    0   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB     2047MiB |
|    0   N/A  N/A   2354166      G   gnome-control-center                0MiB |
|    0   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A   3201740      G   /usr/bin/gnome-shell                0MiB |
|    1   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB      373MiB |
|    1   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB     1995MiB |
|    1   N/A  N/A   2080100      G   ...oken=13985188176333450559       75MiB |
|    1   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2354166      G   gnome-control-center               39MiB |
|    1   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                156MiB |
|    1   N/A  N/A   3201740      G   /usr/bin/gnome-shell               21MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:07:51 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 455.38       Driver Version: 455.38       CUDA Version: 11.1     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 8000     Off  | 00000000:17:00.0 Off |                  Off |
| 60%   79C    P2   252W / 260W |  33525MiB / 48601MiB |    100%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 8000     Off  | 00000000:65:00.0 Off |                  Off |
| 33%   49C    P8    24W / 260W |   2732MiB / 48598MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB      313MiB |
|    0   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   2080100      G   ...oken=13985188176333450559        0MiB |
|    0   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB      539MiB |
|    0   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB     6249MiB |
|    0   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB    12301MiB |
|    0   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB    12061MiB |
|    0   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB     2047MiB |
|    0   N/A  N/A   2354166      G   gnome-control-center                0MiB |
|    0   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A   3201740      G   /usr/bin/gnome-shell                0MiB |
|    1   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB      373MiB |
|    1   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB     1995MiB |
|    1   N/A  N/A   2080100      G   ...oken=13985188176333450559       75MiB |
|    1   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2354166      G   gnome-control-center               39MiB |
|    1   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                156MiB |
|    1   N/A  N/A   3201740      G   /usr/bin/gnome-shell               21MiB |
+-----------------------------------------------------------------------------+
qThu Jun 17 17:07:56 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 455.38       Driver Version: 455.38       CUDA Version: 11.1     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 8000     Off  | 00000000:17:00.0 Off |                  Off |
| 60%   79C    P2   261W / 260W |  33525MiB / 48601MiB |    100%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 8000     Off  | 00000000:65:00.0 Off |                  Off |
| 33%   49C    P8    24W / 260W |   2732MiB / 48598MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB      313MiB |
|    0   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   2080100      G   ...oken=13985188176333450559        0MiB |
|    0   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB      539MiB |
|    0   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB     6249MiB |
|    0   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB    12301MiB |
|    0   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB    12061MiB |
|    0   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB     2047MiB |
|    0   N/A  N/A   2354166      G   gnome-control-center                0MiB |
|    0   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A   3201740      G   /usr/bin/gnome-shell                0MiB |
|    1   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB      373MiB |
|    1   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB     1995MiB |
|    1   N/A  N/A   2080100      G   ...oken=13985188176333450559       75MiB |
|    1   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2354166      G   gnome-control-center               39MiB |
|    1   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                156MiB |
|    1   N/A  N/A   3201740      G   /usr/bin/gnome-shell               21MiB |
+-----------------------------------------------------------------------------+
q^Csampsa@shannon:~$ top

top - 17:08:09 up 129 days,  2:07,  5 users,  load average: 4,19, 3,85, 4,17
Tasks: 1013 total,   1 running, 1012 sleeping,   0 stopped,   0 zombie
%Cpu(s): 17,3 us,  0,4 sy,  0,0 ni, 81,6 id,  0,0 wa,  0,0 hi,  0,7 si,  0,0 st
MiB Mem : 257473,2 total,  11369,4 free, 147613,5 used,  98490,2 buff/cache
MiB Swap:   2048,0 total,    110,8 free,   1937,2 used. 106898,6 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                          
2241338 liisaida  20   0   42,6g   8,6g 546064 S 126,4   3,4   2205:16 MATLAB                           
2240669 liisaida  20   0   43,1g   8,8g 543384 S 122,8   3,5   2160:51 MATLAB                           
2353045 sampsa    20   0   93,2g  72,1g 662228 S 100,0  28,7 297:02.82 MATLAB                           
1977990 yusuf     20   0 3707976 996,9m  73988 S   1,7   0,4   1184:33 Web Content                      
1001069 yusuf     20   0 2905688   6776   4264 S   1,0   0,0 513:03.82 pulseaudio                       
1977722 yusuf     20   0 4107944 456852 138212 S   1,0   0,2 815:01.50 firefox                          
2199171 sampsa    20   0   39,8g  15,9g 791612 S   0,7   6,3 435:34.48 MATLAB                           
2328756 liisaida  20   0   15692   4880   3300 S   0,7   0,0   4:00.89 top                              
2365999 sampsa    20   0   17500   5352   3584 R   0,7   0,0   0:00.10 top                              
2561550 yusuf     20   0 2653352 233128  66424 S   0,7   0,1 161:09.55 Web Content                      
     11 root      20   0       0      0      0 I   0,3   0,0 384:28.38 rcu_sched                        
     89 root      rt   0       0      0      0 S   0,3   0,0   7:36.78 migration/13                     
    101 root      rt   0       0      0      0 S   0,3   0,0   8:25.83 migration/15                     
   1106 root      20   0  406168  22728   6560 S   0,3   0,0 165:02.58 f2b/server                       
   1452 root     -51   0       0      0      0 S   0,3   0,0  84:51.25 irq/83-nvidia                    
   1454 root      20   0       0      0      0 S   0,3   0,0 124:26.36 nv_queue                         
 386058 astrid    20   0   14,7g   1,6g 407476 S   0,3   0,6 159:34.00 MATLAB                           
 612473 yusuf     20   0   28,6g   4,3g 663036 S   0,3   1,7 425:29.75 MATLAB                           
1170502 yusuf     20   0  321304   1876   1876 S   0,3   0,0   4:04.44 gvfs-afc-volume                  
1384541 sampsa    20   0  226852 117196  56840 S   0,3   0,0 198:40.49 Xtightvnc                        
1384909 sampsa    20   0   29,7g   5,3g 717852 S   0,3   2,1  22814:06 MATLAB                           
1385499 sampsa    20   0 3007848 244468  60500 S   0,3   0,1  19:55.40 cef_helper                       
1385570 sampsa    20   0   34,5g   8,4g 736680 S   0,3   3,4  23963:23 MATLAB                           
1619790 yusuf     20   0  314868 129616  89604 S   0,3   0,0 514:00.72 Xtightvnc                        
2030569 yusuf     20   0   18,1g   3,4g 478376 S   0,3   1,4  97:01.21 MATLAB                           
2198752 sampsa    20   0  629148  61704  47760 S   0,3   0,0   0:15.23 unity-settings-                  
2223312 sampsa    20   0 3020640 229064  75340 S   0,3   0,1   8:25.28 MATLABWindow                     
2226884 frank     20   0 3092100 240348  60228 S   0,3   0,1   4:37.11 MATLABWindow                     
2226908 frank     20   0 3093984 238040  59324 S   0,3   0,1   4:37.53 MATLABWindow                     
2269761 sampsa    20   0 2399916 152624  61244 S   0,3   0,1   2:57.44 MATLABWindow                     
2338699 root      20   0       0      0      0 I   0,3   0,0   0:01.19 kworker/11:2-mm_percpu_wq        
2704346 theo      20   0  627076   8648   5720 S   0,3   0,0  11:07.75 unity-settings-                  
      1 root      20   0  169880   9788   4932 S   0,0   0,0  18:18.46 systemd                          
      2 root      20   0       0      0      0 S   0,0   0,0   0:07.47 kthreadd                         
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                           
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                       
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd             
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                     
     10 root      20   0       0      0      0 S   0,0   0,0   2:54.48 ksoftirqd/0                      
     12 root      rt   0       0      0      0 S   0,0   0,0   0:33.65 migration/0                      
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                    
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                          
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                          
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                    
     17 root      rt   0       0      0      0 S   0,0   0,0   8:17.58 migration/1                      
     18 root      20   0       0      0      0 S   0,0   0,0   1:43.35 ksoftirqd/1                      
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd             
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                          
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                    
     23 root      rt   0       0      0      0 S   0,0   0,0   0:32.56 migration/2                      
sampsa@shannon:~$ nvidia-smi
Thu Jun 17 17:08:13 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 455.38       Driver Version: 455.38       CUDA Version: 11.1     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 8000     Off  | 00000000:17:00.0 Off |                  Off |
| 60%   79C    P2   257W / 260W |  33525MiB / 48601MiB |    100%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 8000     Off  | 00000000:65:00.0 Off |                  Off |
| 33%   49C    P8    24W / 260W |   2732MiB / 48598MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB      313MiB |
|    0   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   2080100      G   ...oken=13985188176333450559        0MiB |
|    0   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB      539MiB |
|    0   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB     6249MiB |
|    0   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB    12301MiB |
|    0   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB    12061MiB |
|    0   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB     2047MiB |
|    0   N/A  N/A   2354166      G   gnome-control-center                0MiB |
|    0   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A   3201740      G   /usr/bin/gnome-shell                0MiB |
|    1   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB      373MiB |
|    1   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB     1995MiB |
|    1   N/A  N/A   2080100      G   ...oken=13985188176333450559       75MiB |
|    1   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2353045      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2354166      G   gnome-control-center               39MiB |
|    1   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                156MiB |
|    1   N/A  N/A   3201740      G   /usr/bin/gnome-shell               21MiB |
+-----------------------------------------------------------------------------+
sampsa@shannon:~$ kill 2353045
sampsa@shannon:~$ nvidia-smi
Thu Jun 17 17:08:51 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 455.38       Driver Version: 455.38       CUDA Version: 11.1     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 8000     Off  | 00000000:17:00.0 Off |                  Off |
| 60%   79C    P2   250W / 260W |  31478MiB / 48601MiB |    100%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 8000     Off  | 00000000:65:00.0 Off |                  Off |
| 33%   49C    P8    24W / 260W |   2732MiB / 48598MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB      313MiB |
|    0   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    0   N/A  N/A   2080100      G   ...oken=13985188176333450559        0MiB |
|    0   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB      539MiB |
|    0   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB     6249MiB |
|    0   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB    12301MiB |
|    0   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB    12061MiB |
|    0   N/A  N/A   2354166      G   gnome-control-center                0MiB |
|    0   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A   3201740      G   /usr/bin/gnome-shell                0MiB |
|    1   N/A  N/A      1184      G   /usr/lib/xorg/Xorg                 57MiB |
|    1   N/A  N/A    612473      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   1384909      C   ...R2021a/bin/glnxa64/MATLAB      373MiB |
|    1   N/A  N/A   1385570      C   ...R2021a/bin/glnxa64/MATLAB     1995MiB |
|    1   N/A  N/A   2080100      G   ...oken=13985188176333450559       75MiB |
|    1   N/A  N/A   2199171      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2238393      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2240669      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2241338      C   ...R2021a/bin/glnxa64/MATLAB        0MiB |
|    1   N/A  N/A   2354166      G   gnome-control-center               39MiB |
|    1   N/A  N/A   3201634      G   /usr/lib/xorg/Xorg                156MiB |
|    1   N/A  N/A   3201740      G   /usr/bin/gnome-shell               21MiB |
+-----------------------------------------------------------------------------+
sampsa@shannon:~$ w
 17:09:21 up 129 days,  2:09,  5 users,  load average: 4,71, 4,04, 4,21
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
sampsa   :1       :1               09huhti21 ?xdm?  38days  0.01s /usr/lib/gdm3/gdm-x-session --run-script
sampsa   pts/1    85.76.51.40      14:59    1:36m  0.27s  0.27s -bash
sampsa   pts/7    130.230.156.47   17:07    0.00s  0.06s  0.02s w
liisaida pts/11   37.98.136.175    09:47    7:21m  4:01   4:01  top
sampsa   pts/6    85.76.51.40      15:08    1:22m  0.04s  0.04s -bash
sampsa@shannon:~$ cd /media/datadisk/frank
sampsa@shannon:/media/datadisk/frank$ ls
perepi  zeffiro_interface-Current
sampsa@shannon:/media/datadisk/frank$ cd zeffiro_interface-Current/
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current$ ls
LICENSE    data  m      plugins                zeffiro_interface.m            zeffiro_plugins.ini
README.md  fig   mlapp  zeffiro_interface.ini  zeffiro_interface_nodisplay.m
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current$ cd m
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m$ cd command_line_tools/
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m/command_line_tools$ cd scripts/
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m/command_line_tools/scripts$ pico script_zef_make_all.m 
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m/command_line_tools/scripts$ cd ..
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m/command_line_tools$ cat zef_make_all_nodisplay.m 
zef.source_interpolation_on = 1; 
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]); 
[zef.nodes,zef.nodes_b,zef.tetra,zef.sigma_ind,zef.surface_triangles]=fem_mesh([]);
zef.tetra_aux = zef.tetra; 
[zef.sigma,zef.brain_ind,zef.non_source_ind,zef.nodes,zef.tetra,zef.sigma_prisms,zef.prisms,zef.submesh_ind]=zef_sigma([]); 
zef.n_sources_mod = 1; 
zef.source_ind = []; 
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]);
[zef.sensors_attached_volume] = attach_sensors_volume(zef.sensors);
lead_field_matrix;


sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m/command_line_tools$ cat zef_make_all_nodisplay.m 
zef.source_interpolation_on = 1; 
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]); 
[zef.nodes,zef.nodes_b,zef.tetra,zef.sigma_ind,zef.surface_triangles]=fem_mesh([]);
zef.tetra_aux = zef.tetra; 
[zef.sigma,zef.brain_ind,zef.non_source_ind,zef.nodes,zef.tetra,zef.sigma_prisms,zef.prisms,zef.submesh_ind]=zef_sigma([]); 
zef.n_sources_mod = 1; 
zef.source_ind = []; 
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]);
[zef.sensors_attached_volume] = attach_sensors_volume(zef.sensors);
lead_field_matrix;


sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m/command_line_tools$ cd ..
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m$ cat lead_field_matrix.m 
%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
tic;

if zef.source_direction_mode == 1
zef.lf_param.direction_mode = 'cartesian';
end
if zef.source_direction_mode == 2
zef.lf_param.direction_mode = 'normal';
end
if zef.source_direction_mode == 3
zef.lf_param.direction_mode = 'face_based';
end
if isfield(zef,'preconditioner')
if zef.preconditioner == 1
zef.lf_param.precond = 'cholinc';
elseif zef.preconditioner == 2
zef.lf_param.precond = 'ssor';
end
end
if isfield(zef,'preconditioner_tolerance')
zef.lf_param.cholinc_tol = zef.preconditioner_tolerance;
else
zef.lf_param.cholinc_tol = 0.001;
end
if isfield(zef,'solver_tolerance')
zef.lf_param.pcg_tol = zef.solver_tolerance;
else
zef.lf_param.pcg_tol = 1e-8;
end
zef.aux_vec = [];
zef.aux_vec_sources = zeros(length(zef.compartment_tags),1);
for zef_i = 1 : length(zef.compartment_tags)
zef.aux_vec_sources(zef_i) = evalin('base',['isequal(zef.' zef.compartment_tags{zef_i} '_sources_old, zef.' zef.compartment_tags{zef_i} '_sources);']);
end

if isempty(zef.source_ind) || not(zef.n_sources == zef.n_sources_old) || ismember(false,zef.aux_vec_sources)
if isempty(zef.non_source_ind)
zef.aux_vec = zef.brain_ind;
else
zef.aux_vec = setdiff(zef.brain_ind,zef.non_source_ind);
end
zef.aux_vec = zef.aux_vec(randperm(length(zef.aux_vec)));
zef.n_sources_old = zef.n_sources;
for zef_i = 1 : length(zef.compartment_tags)
evalin('base',['zef.' zef.compartment_tags{zef_i} '_sources_old = zef.' zef.compartment_tags{zef_i} '_sources;']);
end
clear zef_i;
zef.lf_tag = zef.imaging_method_cell{zef.imaging_method};
zef.source_ind = zef.aux_vec(1:min(zef.n_sources,length(zef.aux_vec)));
zef.n_sources_mod = 0;
end
zef.sensors_aux = zef.sensors;
zef.nodes_aux = zef.nodes/1000;
if ismember(zef.imaging_method,[1,4,5]) & size(zef.sensors,2) == 3
zef.sensors_aux = zef.sensors_attached_volume(:,1:3)/1000;
elseif ismember(zef.imaging_method,[2,3])
zef.sensors_aux(:,1:3) = zef.sensors_aux(:,1:3)/1000;
else
zef.sensors_aux = zef.sensors_attached_volume;
end

zef.lf_param.dipole_mode = 1;

if zef.imaging_method == 1 
if size(zef.sensors,2) == 6
zef.lf_param.impedances = zef.sensors(:,6);
end
if evalin('base','zef.prism_layers') && not(isempty(zef.prisms))
[zef.L, zef.source_positions, zef.source_directions] = lead_field_eeg_fem(zef.nodes_aux,{zef.tetra,zef.prisms},{zef.sigma(:,1),zef.sigma_prisms},zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
else
[zef.L, zef.source_positions, zef.source_directions] = lead_field_eeg_fem(zef.nodes_aux,zef.tetra,zef.sigma(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
end
end

if zef.imaging_method == 2;
if evalin('base','zef.prism_layers') && not(isempty(zef.prisms))
[zef.L, zef.source_positions, zef.source_directions] = lead_field_meg_fem(zef.nodes_aux,{zef.tetra,zef.prisms},{zef.sigma(:,1),zef.sigma_prisms},zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param); 
else
[zef.L, zef.source_positions, zef.source_directions] = lead_field_meg_fem(zef.nodes_aux,zef.tetra,zef.sigma(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param); 
end
end

if zef.imaging_method == 3;
if evalin('base','zef.prism_layers') && not(isempty(zef.prisms))
[zef.L, zef.source_positions, zef.source_directions] = lead_field_meg_grad_fem(zef.nodes_aux,{zef.tetra,zef.prisms},{zef.sigma(:,1),zef.sigma_prisms},zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param); 
else
[zef.L, zef.source_positions, zef.source_directions] = lead_field_meg_grad_fem(zef.nodes_aux,zef.tetra,zef.sigma(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param); 
end
end

if zef.imaging_method == 4
if size(zef.sensors,2) == 6
zef.lf_param.impedances = zef.sensors(:,6);
end
if evalin('base','zef.prism_layers') && not(isempty(zef.prisms))
[zef.L, zef.inv_bg_data, zef.source_positions, zef.source_directions, zef.eit_ind, zef.eit_count] = lead_field_eit_fem(zef.nodes_aux,{zef.tetra,zef.prisms},{zef.sigma(:,1),zef.sigma_prisms},zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
else
[zef.L, zef.inv_bg_data, zef.source_positions, zef.source_directions, zef.eit_ind, zef.eit_count] = lead_field_eit_fem(zef.nodes_aux,zef.tetra,zef.sigma(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
end
end

if zef.imaging_method == 5;
if size(zef.sensors,2) == 6
zef.lf_param.impedances = zef.sensors(:,6);
end
if evalin('base','zef.prism_layers') && not(isempty(zef.prisms))
[zef.L, zef.S, zef.source_positions, zef.source_directions, zef.eit_ind, zef.eit_count] = lead_field_tes_fem(zef.nodes_aux,{zef.tetra,zef.prisms},{zef.sigma(:,1),zef.sigma_prisms},zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
else
[zef.L, zef.S, zef.source_positions, zef.source_directions, zef.eit_ind, zef.eit_count] = lead_field_tes_fem(zef.nodes_aux, zef.tetra,zef.sigma(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
end
end

zef = rmfield(zef,{'nodes_aux','sensors_aux','aux_vec','aux_vec_sources'});

zef.lead_field_time = toc;

if zef.location_unit == 1 
zef.source_positions = 1000*zef.source_positions;
zef.location_unit_current = 1;
end

if zef.location_unit == 2 
zef.source_positions = 100*zef.source_positions;
zef.location_unit_current = 2;
end

if zef.location_unit == 3 
zef.location_unit_current = 3;
end

if zef.source_interpolation_on
[zef.source_interpolation_ind] = source_interpolation([]);
end
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m$ pico lead_field_matrix.m 
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m$ cd ..
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current$ ls
LICENSE    data  m      plugins                zeffiro_interface.m            zeffiro_plugins.ini
README.md  fig   mlapp  zeffiro_interface.ini  zeffiro_interface_nodisplay.m
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current$ cd m
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m$ cd command_line_tools/
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m/command_line_tools$ cat zef_make_all_nodisplay.m 
zef.source_interpolation_on = 1; 
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]); 
[zef.nodes,zef.nodes_b,zef.tetra,zef.sigma_ind,zef.surface_triangles]=fem_mesh([]);
zef.tetra_aux = zef.tetra; 
[zef.sigma,zef.brain_ind,zef.non_source_ind,zef.nodes,zef.tetra,zef.sigma_prisms,zef.prisms,zef.submesh_ind]=zef_sigma([]); 
zef.n_sources_mod = 1; 
zef.source_ind = []; 
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]);
[zef.sensors_attached_volume] = attach_sensors_volume(zef.sensors);
lead_field_matrix;


sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m/command_line_tools$ cd ..
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m$ cd command_line_tools/
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m/command_line_tools$ cd scripts/
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m/command_line_tools/scripts$ cat script_zef_make_all.m 
run('../../../zeffiro_interface_nodisplay');

zef.file_path = [zef.program_path '/data/'];
zef.file = 'zef_magnetometer_ready.mat';

zef_load_nodisplay;

zef.use_gpu = 1;
zef.gpu_num = 2;

zef_make_all_nodisplay;

zef.file = 'zef_magnetometer_ready.mat';
zef.save_switch = 7;
zef_save_nodisplay;

exit;
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m/command_line_tools/scripts$ cd ..
sampsa@shannon:/media/datadisk/frank/zeffiro_interface-Current/m/command_line_tools$ logout
Connection to mat-shannon.rd.tut.fi closed.
wks-95038-mac:~ pursiain$ ssh sampsa@mat-herique.rd.tut.fi
sampsa@mat-herique.rd.tut.fi's password: 
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.8.0-44-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

309 updates can be installed immediately.
165 of these updates are security updates.
To see these additional updates run: apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Thu Jun 17 17:06:07 2021 from 130.230.156.47
sampsa@herique:~$ cd /media/datadisk/
sampsa@herique:/media/datadisk$ ls
alexander  atena  frank  joonas  lost+found  perEpi_p2_LCMV_video2.mat  perepi  sampsa  takala5
sampsa@herique:/media/datadisk$ cd joonas/
sampsa@herique:/media/datadisk/joonas$ ll
total 89520
drwxrwxrwx  4 joonaslahtinen joonaslahtinen     4096 kesä   17 15:41 ./
drwxrwxrwx 14 nobody         nogroup            4096 kesä   17 10:41 ../
drwxrwxrwx  7 root           root               4096 kesä   17 15:41 zeffiro_interface-Current/
drwxrwxrwx  6 joonaslahtinen joonaslahtinen     4096 kesä   17 16:27 zeffiro_interface-master/
-rwxrwxrwx  1 joonaslahtinen joonaslahtinen 91649882 kesä   17 12:03 zeffiro_interface-master.zip*
sampsa@herique:/media/datadisk/joonas$ cd zeffiro_interface-Current/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ cd m
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m$ cd command_line_tools/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools$ cd scripts/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cat script_zef_make_all.m 
run('../../../zeffiro_interface_nodisplay');

zef.file_path = [zef.program_path '/data/'];
zef.file = 'sphere_example.mat';

zef_load_nodisplay;
zef_make_all_nodisplay;

zef.file = 'sphere_example.mat';
zef.save_switch = 7;
zef_save_nodisplay;

exit;
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ pico script_zef_make_all.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nohup matlab -nodesktop -nodisplay -nosplash < script_zef_make_all.m 1>zef_out.txt 2>zef_error.txt &
[1] 10955
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ top

top - 17:25:00 up  1:15,  3 users,  load average: 0,16, 0,09, 0,09
Tasks: 594 total,   1 running, 593 sleeping,   0 stopped,   0 zombie
%Cpu(s):  6,4 us,  0,6 sy,  0,0 ni, 92,8 id,  0,2 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 119734,5 free,   6359,8 used,   2450,2 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 120851,8 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
  10955 sampsa    20   0   16,5g   1,4g 471400 S 131,1   1,1   0:08.20 MATLAB                                                                
   3510 sampsa    20   0 2580720 210204  59744 S   3,0   0,2   2:26.98 cef_helper                                                            
   5954 joonasl+  20   0 2374680 209304  60300 S   2,6   0,2   2:02.08 cef_helper                                                            
   2305 sampsa    20   0   22,4g   1,4g 412296 S   2,3   1,1   2:52.51 MATLAB                                                                
   4785 joonasl+  20   0   24,3g   2,5g 636096 S   2,3   2,0   3:52.37 MATLAB                                                                
     11 root      20   0       0      0      0 I   0,3   0,0   0:06.90 rcu_sched                                                             
   1128 root      20   0  402600  23068  10244 S   0,3   0,0   0:03.19 f2b/server                                                            
   4544 joonasl+  20   0  317624   9088   8036 S   0,3   0,0   0:00.01 goa-identity-se                                                       
  11691 sampsa    20   0   17004   4648   3544 R   0,3   0,0   0:00.04 top                                                                   
      1 root      20   0  167996  11800   8304 S   0,0   0,0   0:02.67 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/0                                                           
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.06 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.60 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.69 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.67 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.68 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.69 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:25:06 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P0    44W / 125W |    485MiB /  7982MiB |     37%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   31C    P8     6W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    0   N/A  N/A     10955      C   ...R2020b/bin/glnxa64/MATLAB      247MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi -l
Thu Jun 17 17:25:17 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8    10W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P0    79W / 125W |    557MiB /  7979MiB |     49%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
|    1   N/A  N/A     10955      C   ...R2020b/bin/glnxa64/MATLAB      451MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:25:22 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8    10W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   40C    P0    81W / 125W |    557MiB /  7979MiB |     50%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
|    1   N/A  N/A     10955      C   ...R2020b/bin/glnxa64/MATLAB      451MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:25:27 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8    10W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   43C    P0    82W / 125W |    557MiB /  7979MiB |     49%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
|    1   N/A  N/A     10955      C   ...R2020b/bin/glnxa64/MATLAB      451MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:25:32 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8    10W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   45C    P0    80W / 125W |    557MiB /  7979MiB |     49%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
|    1   N/A  N/A     10955      C   ...R2020b/bin/glnxa64/MATLAB      451MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:25:37 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8    10W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   47C    P0    81W / 125W |    557MiB /  7979MiB |     49%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
|    1   N/A  N/A     10955      C   ...R2020b/bin/glnxa64/MATLAB      451MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:25:42 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8    10W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   46C    P0    36W / 125W |    499MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
|    1   N/A  N/A     10955      C   ...R2020b/bin/glnxa64/MATLAB      393MiB |
+-----------------------------------------------------------------------------+
^C[1]+  Done                    nohup matlab -nodesktop -nodisplay -nosplash < script_zef_make_all.m > zef_out.txt 2> zef_error.txt
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ top

top - 17:25:50 up  1:16,  3 users,  load average: 0,52, 0,20, 0,13
Tasks: 590 total,   1 running, 589 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,3 us,  0,2 sy,  0,0 ni, 99,5 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 120619,0 free,   5354,0 used,   2571,6 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 121868,4 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
   5954 joonasl+  20   0 2374680 208444  60300 S   3,3   0,2   2:03.38 cef_helper                                                            
   3510 sampsa    20   0 2580720 209356  59744 S   3,0   0,2   2:28.24 cef_helper                                                            
   4785 joonasl+  20   0   24,3g   2,5g 636096 S   2,6   2,0   3:53.55 MATLAB                                                                
   2305 sampsa    20   0   22,4g   1,4g 412296 S   2,3   1,1   2:53.57 MATLAB                                                                
  12784 sampsa    20   0   17004   4652   3544 R   0,7   0,0   0:00.05 top                                                                   
    404 root      20   0       0      0      0 S   0,3   0,0   0:00.38 usb-storage                                                           
   8380 root      20   0       0      0      0 I   0,3   0,0   0:00.01 kworker/19:0-mm_percpu_wq                                             
      1 root      20   0  167996  11800   8304 S   0,0   0,0   0:02.67 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:06.96 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.06 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.60 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.67 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.68 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.69 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi -l
Thu Jun 17 17:25:56 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   43C    P8     8W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:26:01 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   32C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   42C    P8     8W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:26:06 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   41C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:26:11 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   41C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:26:16 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   40C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:26:21 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   40C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:26:26 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   39C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:26:31 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   39C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:26:36 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   38C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:26:41 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   38C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:26:46 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   38C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
Thu Jun 17 17:26:51 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8    10W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
^Csampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:26:57 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:27:00 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   37C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ top

top - 17:27:23 up  1:18,  3 users,  load average: 0,36, 0,22, 0,14
Tasks: 588 total,   1 running, 587 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,3 us,  0,1 sy,  0,0 ni, 99,5 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 120618,7 free,   5354,3 used,   2571,7 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 121868,1 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
   3510 sampsa    20   0 2580720 209196  59744 S   3,3   0,2   2:31.20 cef_helper                                                            
   5954 joonasl+  20   0 2374680 209256  60300 S   3,3   0,2   2:06.41 cef_helper                                                            
   4785 joonasl+  20   0   24,3g   2,5g 636096 S   3,0   2,0   3:56.70 MATLAB                                                                
   2305 sampsa    20   0   22,4g   1,4g 412296 S   2,6   1,1   2:56.00 MATLAB                                                                
  12800 sampsa    20   0   17004   4648   3540 R   0,7   0,0   0:00.15 top                                                                   
     11 root      20   0       0      0      0 I   0,3   0,0   0:07.10 rcu_sched                                                             
   4365 joonasl+  20   0  241500 115896  58528 S   0,3   0,1   0:21.37 Xtightvnc                                                             
      1 root      20   0  167996  11800   8304 S   0,0   0,0   0:02.67 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/0                                                           
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.06 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.60 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.68 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.68 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.69 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/7                                                           
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:27:30 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   36C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:27:36 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   35C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi 
Thu Jun 17 17:27:48 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8    10W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   35C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi 
Thu Jun 17 17:27:50 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   35C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ matlab -nodesktop
MATLAB is selecting SOFTWARE OPENGL rendering.

                                                           < M A T L A B (R) >
                                                 Copyright 1984-2020 The MathWorks, Inc.
                                             R2020b Update 1 (9.9.0.1495850) 64-bit (glnxa64)
                                                            September 30, 2020

 
To get started, type doc.
For product information, visit www.mathworks.com.
 
>> gpuDeviceCount               

ans =

     2

>> quit
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ ll
total 20
drwxrwxrwx 2 root   root   4096 kesä   17 17:24 ./
drwxrwxrwx 3 root   root   4096 kesä   17 15:41 ../
-rwxrwxrwx 1 root   root    287 kesä   17 17:24 script_zef_make_all.m*
-rw-rw-r-- 1 sampsa sampsa  357 kesä   17 17:25 zef_error.txt
-rw-rw-r-- 1 sampsa sampsa  550 kesä   17 17:25 zef_out.txt
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ top

top - 17:28:33 up  1:19,  3 users,  load average: 0,54, 0,30, 0,17
Tasks: 590 total,   1 running, 589 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,3 us,  0,2 sy,  0,0 ni, 99,5 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 120605,7 free,   5366,2 used,   2572,7 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 121856,2 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
   4785 joonasl+  20   0   24,3g   2,5g 636096 S   4,3   2,0   4:05.92 MATLAB                                                                
   2305 sampsa    20   0   22,4g   1,4g 412296 S   3,0   1,1   2:57.82 MATLAB                                                                
   3510 sampsa    20   0 2580720 209680  59744 S   3,0   0,2   2:33.39 cef_helper                                                            
   5954 joonasl+  20   0 2374680 209164  60300 S   3,0   0,2   2:08.62 cef_helper                                                            
   4365 joonasl+  20   0  241500 115896  58528 S   1,0   0,1   0:22.25 Xtightvnc                                                             
   1334 gdm       20   0  319596   8976   7972 S   0,3   0,0   0:00.14 gvfs-afc-volume                                                       
  10152 joonasl+  20   0   14124   6040   4548 S   0,3   0,0   0:01.20 sshd                                                                  
  14348 sampsa    20   0   17004   4704   3596 R   0,3   0,0   0:00.13 top                                                                   
      1 root      20   0  167996  11800   8304 S   0,0   0,0   0:02.67 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:07.20 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.06 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.60 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.68 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.68 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.69 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:28:38 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   34C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:24 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:26 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:27 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:29 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:31 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:35 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:36 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:38 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:39 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8    10W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:40 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:41 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:44 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8    10W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:46 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:47 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:48 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:50 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:51 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:53 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:29:54 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   33C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nvidia-smi
Thu Jun 17 17:31:12 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.102.04   Driver Version: 450.102.04   CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro RTX 4000     Off  | 00000000:17:00.0 Off |                  N/A |
| 30%   31C    P8     9W / 125W |    238MiB /  7982MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Quadro RTX 4000     Off  | 00000000:65:00.0 Off |                  N/A |
| 30%   32C    P8     7W / 125W |    106MiB /  7979MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                  4MiB |
|    0   N/A  N/A      4785      C   ...R2020b/bin/glnxa64/MATLAB      229MiB |
|    1   N/A  N/A      1287      G   /usr/lib/xorg/Xorg                 94MiB |
|    1   N/A  N/A      1499      G   /usr/bin/gnome-shell                7MiB |
+-----------------------------------------------------------------------------+
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ top

top - 17:31:29 up  1:22,  3 users,  load average: 0,15, 0,21, 0,16
Tasks: 589 total,   1 running, 588 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,4 us,  0,1 sy,  0,0 ni, 99,5 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 120565,9 free,   5405,3 used,   2573,4 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 121816,9 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
   3510 sampsa    20   0 2580720 210084  59744 S   3,6   0,2   2:39.02 cef_helper                                                            
   4785 joonasl+  20   0   24,3g   2,5g 636100 S   3,0   2,0   4:23.54 MATLAB                                                                
   5954 joonasl+  20   0 2374680 209260  60300 S   3,0   0,2   2:14.38 cef_helper                                                            
   2305 sampsa    20   0   22,4g   1,4g 412296 S   2,6   1,1   3:02.45 MATLAB                                                                
  14670 sampsa    20   0   17004   4560   3452 R   0,7   0,0   0:00.11 top                                                                   
     11 root      20   0       0      0      0 I   0,3   0,0   0:07.45 rcu_sched                                                             
   1032 root      20   0   81952   3652   3360 S   0,3   0,0   0:00.61 irqbalance                                                            
   4365 joonasl+  20   0  241500 115896  58528 S   0,3   0,1   0:25.22 Xtightvnc                                                             
      1 root      20   0  167996  11800   8304 S   0,0   0,0   0:02.68 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/0                                                           
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.06 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.60 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.68 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.69 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.69 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ kill 2305
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ top

top - 17:31:39 up  1:22,  3 users,  load average: 0,12, 0,20, 0,16
Tasks: 585 total,   1 running, 584 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,5 us,  0,2 sy,  0,0 ni, 99,3 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 121811,9 free,   4164,1 used,   2568,7 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 123062,6 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
   4785 joonasl+  20   0   24,3g   2,5g 636100 S   6,0   2,0   4:24.48 MATLAB                                                                
   5954 joonasl+  20   0 2374680 209260  60300 S   3,0   0,2   2:14.70 cef_helper                                                            
   4382 joonasl+  20   0  331940  50236  36328 S   1,7   0,0   0:02.57 metacity                                                              
   4365 joonasl+  20   0  241500 115896  58528 S   1,0   0,1   0:25.55 Xtightvnc                                                             
  10152 joonasl+  20   0   14124   6040   4548 S   1,0   0,0   0:02.28 sshd                                                                  
   2013 sampsa    20   0  241644 101972  49892 S   0,7   0,1   0:06.07 Xtightvnc                                                             
  14758 sampsa    20   0   17004   4592   3484 R   0,7   0,0   0:00.05 top                                                                   
   1442 root     -51   0       0      0      0 S   0,3   0,0   0:00.91 irq/83-nvidia                                                         
   2026 sampsa    20   0 1170088  81348  57216 S   0,3   0,1   0:01.19 nautilus                                                              
   4584 joonasl+  20   0  691904  59008  43916 S   0,3   0,0   0:04.63 gnome-panel                                                           
      1 root      20   0  167996  11800   8304 S   0,0   0,0   0:02.69 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:07.46 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.06 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.60 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.68 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.69 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.69 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ top

top - 17:46:27 up  1:37,  2 users,  load average: 0,57, 0,37, 0,20
Tasks: 564 total,   1 running, 563 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,0 us,  0,1 sy,  0,0 ni, 99,9 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 124187,0 free,   1687,3 used,   2670,3 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 125599,3 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
  10746 joonasl+  20   0  967256  53020  40384 S   0,7   0,0   0:01.02 gnome-terminal-                                                       
  15567 sampsa    20   0   17004   4648   3544 R   0,7   0,0   0:01.95 top                                                                   
   4365 joonasl+  20   0  235928 110628  53260 S   0,3   0,1   0:35.39 Xtightvnc                                                             
   4460 joonasl+  20   0  881044  76580  62144 S   0,3   0,1   0:01.27 gnome-flashback                                                       
   4584 joonasl+  20   0  691904  59008  43916 S   0,3   0,0   0:05.63 gnome-panel                                                           
      1 root      20   0  167996  11812   8304 S   0,0   0,0   0:03.01 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:08.28 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.07 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.60 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.69 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.72 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/7                                                           
     54 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/7                                                           
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m$ pico tetra_in_compartment.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ cd .
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ cd ..
sampsa@herique:/media/datadisk/joonas$ chmod 777 -R zeffiro_interface-Current/
chmod: changing permissions of 'zeffiro_interface-Current/': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/zeffiro_interface_nodisplay.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/mlapp/zeffiro_interface_mesh_visualization_tool_app.mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/mlapp/zeffiro_interface_mesh_tool_app.mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/mlapp/zeffiro_interface_segmentation_tool_app.mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/mlapp/zeffiro_interface_additional_options_app.mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/zeffiro_interface.ini': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/DipoleScan': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/DipoleScan/zef_dipole_start.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/DipoleScan/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/DipoleScan/m/zef_dipoleScan.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/DipoleScan/debug.log': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/DipoleScan/dipole_app.mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ClassicalSparseMethods': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ClassicalSparseMethods/README': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ClassicalSparseMethods/CSM_app.mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ClassicalSparseMethods/CSM_app_start.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ClassicalSparseMethods/zef_CSM_iteration.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASROIInversion': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASROIInversion/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASROIInversion/m/zef_update_ias_roi.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASROIInversion/m/ias_map_estimation_roi.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASROIInversion/m/zef_switch_roi_mode.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASROIInversion/m/zef_init_ias_roi.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASROIInversion/m/zef_iasroi_plot_roi.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASROIInversion/m/ias_iteration_roi.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASROIInversion/fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASROIInversion/fig/ias_map_estimation_roi.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/mlapp/zeffiro_interface_lf_bank_tool.mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/zef_lf_bank_update_noise_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/zef_combine_lead_fields.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/zef_lf_bank_compute_lead_fields.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/zef_lf_bank_update_measurements.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/lead_field_normalization_functions': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_whitening.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_whitening_diagonal_identity.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_normalize_mean_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_no_normalization.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_normalize_maximum_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_normalize_frobenius.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/zef_delete_lf_item.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/zef_lf_bank_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/zef_init_lf_bank_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/zef_add_lf_item.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LFBankTool/m/zef_update_lf_bank_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroTopography': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroTopography/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroTopography/m/zef_evaluate_topography.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroTopography/m/zef_topography.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroTopography/m/zef_update_topography.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroTopography/m/zef_init_topography.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroTopography/fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroTopography/fig/zeffiro_interface_topography.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/README': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_ias_multires': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_ias_multires/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_ias_multires/m/exp_ias_iteration_multires.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_ias_multires/m/exp_ias_map_estimation_multires.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_ias_multires/m/zef_update_exp_ias_multires.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_ias_multires/m/zef_init_exp_ias_multires.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_ias_multires/fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_ias_multires/fig/exp_ias_map_estimation_multires.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_em_multires': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_em_multires/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_em_multires/m/zef_init_exp_em_multires.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_em_multires/m/exp_em_iteration_multires.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_em_multires/m/exp_em_map_estimation_multires.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_em_multires/m/zef_update_exp_em_multires.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_em_multires/fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_em_multires/fig/exp_em_map_estimation_multires.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_em': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_em/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_em/m/exp_em_map_estimation.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_em/m/exp_em_iteration.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_em/m/zef_update_exp_em.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_em/m/zef_init_exp_em.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_em/fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_em/fig/exp_em_map_estimation.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/common': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/common/exp_make_multires_dec.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/common/L1_optimization.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/common/EM_Lasso.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_ias': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_ias/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_ias/m/exp_ias_iteration.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_ias/m/zef_update_exp_ias.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_ias/m/exp_ias_map_estimation.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_ias/m/zef_init_exp_ias.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_ias/fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/EXP/exp_ias/fig/exp_ias_map_estimation.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ReconstructionTool': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ReconstructionTool/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ReconstructionTool/m/zef_reconstructionTool_replace.asv': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ReconstructionTool/m/zef_reconstructionTool_apply.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ReconstructionTool/m/zef_reconstructionTool_refresh.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ReconstructionTool/m/zef_reconstructionTool_import.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ReconstructionTool/m/zef_reconstructionTool_addCurrent2bank.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ReconstructionTool/m/apply_functions': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ReconstructionTool/m/apply_functions/zef_reconstructionTool_power.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ReconstructionTool/m/apply_functions/zef_reconstructionTool_mean.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ReconstructionTool/m/zef_reconstructionTool_replace.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ReconstructionTool/m/zef_reconstructionTool_apply.asv': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ReconstructionTool/m/zef_reconstructionTool_delete.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ReconstructionTool/zef_reconstructionTool_app.mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ReconstructionTool/zef_reconstructionTool_start.asv': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ReconstructionTool/zef_reconstructionTool_start.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/GMMClustering': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/GMMClustering/GMMclustering_app.mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/GMMClustering/README': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/GMMClustering/GMMclustering_start.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/GMMClustering/zef_GMMcluster.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/GMMClustering/zef_PlotGMMcluster.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/HBSampler': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/HBSampler/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/HBSampler/m/mcmc_sampler.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/HBSampler/m/hb_sampler.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/HBSampler/m/zef_init_hb_sampler.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/HBSampler/m/gibbs_sampler.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/HBSampler/m/zef_update_hb_sampler.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/HBSampler/fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/HBSampler/fig/hb_sampler.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/PlotMeshesProto': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/PlotMeshesProto/plot_meshes_proto.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/PlotMeshesProto/zef_3D_plot_specs.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/MNETool': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/MNETool/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/MNETool/m/zef_find_mne_reconstruction.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/MNETool/m/zef_minimum_norm_estimation.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/MNETool/m/zef_update_mne.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/MNETool/m/zef_init_mne.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/MNETool/fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/MNETool/fig/zef_mne_tool.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASInversion': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASInversion/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASInversion/m/zef_update_ias.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASInversion/m/zef_init_ias.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASInversion/m/ias_iteration.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASInversion/m/ias_map_estimation.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASInversion/fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/IASInversion/fig/ias_map_estimation.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/mlapp/zef_ES_optimization_app.mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/others': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/others/red_wrong_mark.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/others/green_check_mark.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_error_criteria.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_clear_plot_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_optimization_update.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_update_reconstruction.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_find_currents.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_plot_barplot.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_clear_plot_data.asv': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_find_parameters.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_optimize_current.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_4x1_fun.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_objective_function.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_rwnnz.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_optimization.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_plot_barplot_window.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_plot_error_chart.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_plot_error_chart_mouseclick.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_score_sys.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_4x1_sensors.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_plot_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_update_plot_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_plot_current_pattern.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_optimization_init.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/mlapp/zeffiro_interface_filter_tool.mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_delete_filter_item.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_load_epoch_points.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_move_up_filter_item.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_substitute_noise_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_load.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_update_filter_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_save_processed_data_as.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_ellip_band_stop_filter.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_zero_reference.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_ellip_high_pass_filter.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_simple_downsampling_filter.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_define_time_interval.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_threshold_epoching.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_manual_epoching.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_exclude_channels.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_ellip_low_pass_filter.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_simple_ica_cleaning.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_select_channels.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_constant_epoching.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_init_filter_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_reset.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_move_down_filter_item.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_import_raw_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_save_as.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_substitute_raw_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_substitute_measurement_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_plot_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_raw_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_schroll_bar.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_add_filter_item.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/RAMUSSampler': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/RAMUSSampler/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/RAMUSSampler/m/ramus_sampler.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/RAMUSSampler/m/zef_init_ramus_sampler.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/RAMUSSampler/m/ramus_sampling_process.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/RAMUSSampler/m/zef_update_ramus_sampler.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/RAMUSSampler/fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/RAMUSSampler/fig/ramus_sampler.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/FindSyntheticSource': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/FindSyntheticSource/mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/FindSyntheticSource/mlapp/find_synthetic_source_app.mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/FindSyntheticSource/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/FindSyntheticSource/m/zef_plot_source_intensity.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/FindSyntheticSource/m/zef_generate_time_sequence.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/FindSyntheticSource/m/zef_plot_source.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/FindSyntheticSource/m/add_synthetic_source.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/FindSyntheticSource/m/zef_find_source.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/FindSyntheticSource/m/zef_update_fss.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/FindSyntheticSource/m/find_synthetic_source.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/FindSyntheticSource/m/remove_synthetic_source.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/MUSIC': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/MUSIC/README': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/MUSIC/MUSIC_app.mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/MUSIC/MUSIC_iteration.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/MUSIC/MUSIC_app_start.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/Beamformer': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/Beamformer/README': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/Beamformer/zef_beamformer_start.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/Beamformer/zef_beamformer.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/Beamformer/beamformer_app.mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/RAMUSInversion': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/RAMUSInversion/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/RAMUSInversion/m/zef_ramus_inversion_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/RAMUSInversion/m/zef_ramus_iteration.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/RAMUSInversion/m/zef_init_ramus_inversion_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/RAMUSInversion/m/zef_update_ramus_inversion_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/RAMUSInversion/fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/RAMUSInversion/fig/zeffiro_interface_ramus_inversion_tool.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/readme.txt': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_mag2Grad.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_delete.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadFieldProcessingTool_aux2bank_bankPosition.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadFieldProcessingTool_aux2bank_new.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_aux2current.asv': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_aux2current.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_loadTra.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadFieldProcessingTool_add.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_BankTableLabelUpdate.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadFieldProcessingTool_addCurrentData2bank.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_updateTable.asv': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_bank2aux_bank2auxIndex.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_combine.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_delete.asv': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_updateTable.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/LeadFieldProcessingTool_start.asv': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/LeadFieldProcessingTool_start.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/plugins/LeadFieldProcessingTool/LeadFieldProcessingTool_app.mlapp': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_parcellation_reset.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_plot_roi.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_sigma.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_gamma_gpu.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/make_eit_dec.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_set_color.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zeffiro_interface_mesh_visualization_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_import_sensor_names.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_update_parameters.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_toggle_lock_transforms_on.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_add_sensor_name.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/lead_field_meg_grad_fem.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/fem_mesh.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_update_transform_parameters.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/additional_options.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_update_options.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/auxiliary_scripts': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/auxiliary_scripts/getElectrodePositions.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/auxiliary_scripts/getMagnetometerPositions.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_plot_source.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_figure_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_callbackpause.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_mesh_tool_switch.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/print_meshes.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/lead_field_tes_fem.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/merge_lead_field.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_compartment_table_selection.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_parcellation_time_series.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/switch_onoff.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_intensity_1_colormap.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_start_new_project.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_init_sensors_name_table.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_init_sensor_parameters.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_get_surface_mesh.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_mesh_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_import_project.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_add_sensors.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_slidding_callback.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/command_line_tools': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/command_line_tools/zeffiro_interface_nodisplay.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/command_line_tools/zef_save_nodisplay.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/command_line_tools/zef_load_nodisplay.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/command_line_tools/zef_make_all_nodisplay.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/command_line_tools/scripts': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/command_line_tools/scripts/script_zef_make_all.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_update_mesh_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_create_sensors.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_import_surface_mesh_type.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_init_transform_parameters.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_delete_original_surface_meshes.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_create_compartment.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/make_multires_dec.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_save.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_toggle_lock_sensor_names_on.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_get_sensor_points.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_delete_sensors.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/switch_color.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_delete_sensor_sets.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_update.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_update_sensors_name_table.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_load.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_import_segmentation.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/source_interpolation.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/plot_meshes.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_add_compartment.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_close_figs.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_get_mesh.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/synthetic_eit_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_change_size_function.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_get_relative_size.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_init.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_field_downsampling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_import.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zeffiro_interface_segmentation_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_callbackstop.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_find_ig_hyperprior_scale.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_toggle_lock_sensor_sets_on.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_intensity_2_colormap.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_init_options.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_find_source.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_blue_brain_1_colormap.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_add_transform.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_import_parcellation_colortable.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_set_sensor_color.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_create_sensors.asv': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_init_sensors.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/lead_field_eeg_fem.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_delete_original_field.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_exclude_load_fields.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_init_sensors_table.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zeffiro_interface_figure_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_update_find_synthetic_eit_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_update_transform.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_parcellation_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_find_ig_hyperprior.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_plugin.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_transform_table_selection.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_toggle_lock_on.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_determinant.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_visualize_volume.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_plot_hyperprior.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/apply_transform.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_get_sensor_directions.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_init_find_synthetic_eit_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_blue_brain_2_colormap.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_update_transform.asv': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_sensors_table_selection.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_contrast_5_colormap.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_update_parcellation.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_remove_object_fields.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_update_fig_details.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_import_parcellation_points.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/compute_eit_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_make_butterfly_plot.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_downsample_surfaces.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_find_g_hyperprior.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_update_fss.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_reopen_segmentation_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_init_transform.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_update_mesh_visualization_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_contrast_2_colormap.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_close_tools.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_inv_import.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_corr_no_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_corr_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_max_energy_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_corr_max_scaling_max_weighting.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_dtw_no_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_max_energy_max_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_std_no_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_cov_max_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_mean_energy_no_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_mean_energy_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_std_max_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_std_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_cov_no_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_mean_energy_max_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_cov_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_dtw_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_corr_max_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_dtw_max_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_max_energy_no_scaling.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_corr_mean_scaling_mean_weighting.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/time_series_tools/zef_time_series_plot.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_inverse_gamma_gpu.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_butterfly_plot.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_init_butterfly_plot.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_monterosso_colormap.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_contrast_1_colormap.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_smooth_surface.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_plot_parcellation_time_series.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_visualize_surfaces.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/smooth_field.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_build_compartment_table.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/tetra_in_compartment.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_init_fss.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_figure_window.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/lead_field_meg_fem.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_update.asv': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_contrast_3_colormap.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_set_compartment_color.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/process_meshes.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_sensors_name_table_selection.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_import_asc.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/find_synthetic_source.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_update_butterfly_plot.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/lead_field_eit_fem.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_snapshot_movie.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/plot_volume.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_contrast_4_colormap.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_init_compartments.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_delete_compartment.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_intensity_3_colormap.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_find_g_hyperprior_ig.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_find_g_hyperprior_scale.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/inflate_surface.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_parcellation_default.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/lead_field_matrix.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/update_source_positions.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_find_gaussian_prior.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/color_label.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zeffiro_interface_mesh_tool.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/inverse_data_processing': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/inverse_data_processing/zef_processLeadfields.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/inverse_data_processing/zef_normalizeInverseReconstruction.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/inverse_data_processing/zef_getTimeStep.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/inverse_data_processing/zef_getFilteredData.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/inverse_data_processing/zef_postProcessInverse.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zeffiro_interface_additional_options.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/find_synthetic_eit_data.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/attach_sensors_volume.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_delete_transform.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_parcellation_interpolation.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_pushbutton_switch.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_blue_brain_3_colormap.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_init_parcellation.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_update_system_information.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/m/zef_parcellation_colormap.m': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/fig/zeffiro_interface_ramus_inversion_tool.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/fig/find_synthetic_source.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/fig/zeffiro_logo.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/fig/zeffiro_interface_figure_tool.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/fig/zeffiro_interface_segmentation_tool.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/fig/zeffiro_small_logo.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/fig/zeffiro_interface_parcellation_tool.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/fig/additional_options.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/fig/zeffiro_interface_mesh_tool.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/fig/zeffiro_interface.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/fig/find_synthetic_eit_data.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/fig/zeffiro_interface_butterfly_plot.fig': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/LICENSE': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/media': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/media/rec_1_surf.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/media/eit_reconstruction.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/media/time_lapse.avi': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/media/rec_1_vol_cut_1.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/media/aivokuva.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/media/parcellation_tool.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/media/parcellation_brain.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/media/rec_1_vol_cut.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/media/surface_meshes.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/media/volume_mesh.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/media/eit_model.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/media/rec_1_vol_cut_2.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/media/parcellation_correlation.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/media/cem_electrodes.png': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/eeg_1mm_project_settings.mat': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/sphere_example.mat': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/export_and_import_scripts': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/export_and_import_scripts/multi_lead_field_project': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/export_and_import_scripts/multi_lead_field_project/electrodes.zef': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/export_and_import_scripts/multi_lead_field_project/segmentation.zef': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/export_and_import_scripts/multi_lead_field_project/import_multi_lead_field_project.zef': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/export_and_import_scripts/multi_lead_field_project/magnetometers.zef': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/export_and_import_scripts/multi_lead_field_project/gradiometers.zef': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/export_and_import_scripts/import_segmentation.zef': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/export_and_import_scripts/fs2zef.sh': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/sensors.dat': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/segmentation_import_example': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/segmentation_import_example/rh_white.asc': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/segmentation_import_example/outer_skull_points.dat': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/segmentation_import_example/outer_skin_triangles.dat': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/segmentation_import_example/lh_white.asc': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/segmentation_import_example/rh_CerebellumCortex.asc': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/segmentation_import_example/import_segmentation_ASCII.zef': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/segmentation_import_example/outer_skin_points.dat': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/segmentation_import_example/inner_skull_triangles.dat': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/segmentation_import_example/cem_electrodes.dat': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/segmentation_import_example/rh_pial.asc': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/segmentation_import_example/lh_CerebellumCortex.asc': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/segmentation_import_example/lh_pial.asc': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/segmentation_import_example/outer_skull_triangles.dat': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/segmentation_import_example/inner_skull_points.dat': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/data/directions.dat': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/zeffiro_plugins.ini': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/README.md': Operation not permitted
chmod: changing permissions of 'zeffiro_interface-Current/zeffiro_interface.m': Operation not permitted
sampsa@herique:/media/datadisk/joonas$ sudo chmod 777 -R zeffiro_interface-Current/
[sudo] password for sampsa: 
sampsa@herique:/media/datadisk/joonas$ cd zeffiro_interface-Current/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ cd m
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m$ cd command_line_tools/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools$ cd scripts/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cat script_zef_make_all.m 
run('../../../zeffiro_interface_nodisplay');

zef.file_path = [zef.program_path '/data/'];
zef.file = 'sphere_example.mat';

zef_load_nodisplay;

zef.gpu_num = 2;
zef.use_gpu = 1;

zef_make_all_nodisplay;

zef.file = 'sphere_example.mat';
zef.save_switch = 7;
zef_save_nodisplay;

exit;
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ cd ..
sampsa@herique:/media/datadisk/joonas$ cd zeffiro_interface-master/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ cd m
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m$ cat joonas_make_all.m 
run('../../../zeffiro_interface_nodisplay');

zef.file_path = [zef.program_path '/data/'];
zef.file = 'sphere_15kS_1mmMr.mat';

zef_load_nodisplay;

zef.gpu_num = 2;
zef.use_gpu = 1;

zef.source_interpolation_on = 1; 
set(zef.h_source_interpolation_on,'value',1); 
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]); 
[zef.nodes,zef.nodes_b,zef.tetra,zef.sigma_ind,zef.surface_triangles]=fem_mesh([]);
zef.tetra_aux = zef.tetra; 
[zef.sigma,zef.brain_ind,zef.non_source_ind,zef.nodes,zef.tetra,zef.sigma_prisms,zef.prisms,zef.submesh_ind]=zef_sigma([]); 
zef.n_sources_mod = 1; 
zef.source_ind = []; 
set(zef.h_text_elements,'string',num2str(size(zef.tetra,1)+size(zef.prisms,1))); 
set(zef.h_text_nodes,'string',num2str(size(zef.nodes,1)));
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]);
[zef.sensors_attached_volume] = attach_sensors_volume(zef.sensors);
lead_field_matrix;

source_positions = zef.source_positions;
[s_ind_1] = unique(zef.source_interpolation_ind{1});
L = zef.L;
save('SphereSpace.mat','s_ind_1','L','source_positions');

zef.file = 'sphere_15kS_1mmMr.mat';

zef.save_switch = 7;
zef_save_nodisplay;
exit;sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m$ top

top - 17:55:47 up  1:46,  3 users,  load average: 0,18, 0,12, 0,13
Tasks: 579 total,   1 running, 578 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,1 us,  0,1 sy,  0,0 ni, 99,7 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 123920,9 free,   1902,0 used,   2721,7 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 125338,0 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
   4383 joonasl+  20   0 1032492  82700  53856 S   1,7   0,1   0:02.96 nautilus                                                              
   4365 joonasl+  20   0  235928 110772  53404 S   0,7   0,1   0:38.30 Xtightvnc                                                             
    404 root      20   0       0      0      0 S   0,3   0,0   0:00.55 usb-storage                                                           
   4460 joonasl+  20   0  881044  76580  62144 S   0,3   0,1   0:01.79 gnome-flashback                                                       
  10152 joonasl+  20   0   14124   6040   4548 S   0,3   0,0   0:05.89 sshd                                                                  
  20988 sampsa    20   0   17004   4704   3596 R   0,3   0,0   0:00.04 top                                                                   
      1 root      20   0  167996  11812   8304 S   0,0   0,0   0:03.22 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:08.37 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.07 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.60 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.72 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.69 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.72 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/7                                                           
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m$ cat zef_error.txt 
Error using run (line 66)
../../../zeffiro_interface_nodisplay not found.
 
Unable to resolve the name zef.program_path.
 
'zef_load_nodisplay' is not found in the current folder or on the MATLAB path, but exists in:
    /media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools
    /media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools

Change the MATLAB current folder or add its folder to the MATLAB path.
 
Reference to non-existent field 'h_source_interpolation_on'.
 
Reference to non-existent field 'd1_on'.

Error in process_meshes (line 150)
on_val = evalin('base',var_0);
 
Reference to non-existent field 'mesh_resolution'.

Error in fem_mesh (line 7)
mesh_res = evalin('base','zef.mesh_resolution');
 
Reference to non-existent field 'tetra'.
 
Reference to non-existent field 'import_mode'.

Error in zef_sigma (line 13)
if evalin('base','zef.import_mode')
 
Reference to non-existent field 'h_text_elements'.
 
Reference to non-existent field 'h_text_nodes'.
 
Reference to non-existent field 'd1_on'.

Error in process_meshes (line 150)
on_val = evalin('base',var_0);
 
Reference to non-existent field 'sensors'.
 
Reference to non-existent field 'source_direction_mode'.

Error in lead_field_matrix (line 5)
if zef.source_direction_mode == 1
 
Reference to non-existent field 'source_positions'.
 
Reference to non-existent field 'source_interpolation_ind'.
 
Reference to non-existent field 'L'.
 
Error using save
Variable 's_ind_1' not found.
 
'zef_save_nodisplay' is not found in the current folder or on the MATLAB path, but exists in:
    /media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools
    /media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools

Change the MATLAB current folder or add its folder to the MATLAB path.
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m$ top

top - 17:59:56 up  1:50,  3 users,  load average: 0,04, 0,10, 0,11
Tasks: 577 total,   1 running, 576 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,3 us,  0,8 sy,  0,0 ni, 98,9 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 123914,5 free,   1905,0 used,   2725,1 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 125334,3 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
  22887 sampsa    20   0   17004   4704   3596 R  11,8   0,0   0:00.03 top                                                                   
      1 root      20   0  167996  11812   8304 S   0,0   0,0   0:03.23 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:08.43 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.07 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.61 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.72 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.69 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/7                                                           
     54 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/7                                                           
     56 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/7:0H-kblockd                                                  
     57 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/8                                                               
     58 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/8                                                         
     59 root      rt   0       0      0      0 S   0,0   0,0   0:00.65 migration/8                                                           
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m$ cd command_line_tools/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools$ cd scripts/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cat zef_error.txt 
Error using run (line 66)
../../../zeffiro_interface_nodisplay not found.
 
Unable to resolve the name zef.program_path.
 
'zef_load_nodisplay' is not found in the current folder or on the MATLAB path, but exists in:
    /media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools
    /media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools

Change the MATLAB current folder or add its folder to the MATLAB path.
 
Reference to non-existent field 'h_source_interpolation_on'.
 
'process_meshes' is not found in the current folder or on the MATLAB path, but exists in:
    /media/datadisk/joonas/zeffiro_interface-master/m
    /media/datadisk/joonas/zeffiro_interface-Current/m

Change the MATLAB current folder or add its folder to the MATLAB path.
 
'fem_mesh' is not found in the current folder or on the MATLAB path, but exists in:
    /media/datadisk/joonas/zeffiro_interface-master/m
    /media/datadisk/joonas/zeffiro_interface-Current/m

Change the MATLAB current folder or add its folder to the MATLAB path.
 
Reference to non-existent field 'tetra'.
 
'zef_sigma' is not found in the current folder or on the MATLAB path, but exists in:
    /media/datadisk/joonas/zeffiro_interface-master/m
    /media/datadisk/joonas/zeffiro_interface-Current/m

Change the MATLAB current folder or add its folder to the MATLAB path.
 
Reference to non-existent field 'h_text_elements'.
 
Reference to non-existent field 'h_text_nodes'.
 
'process_meshes' is not found in the current folder or on the MATLAB path, but exists in:
    /media/datadisk/joonas/zeffiro_interface-master/m
    /media/datadisk/joonas/zeffiro_interface-Current/m

Change the MATLAB current folder or add its folder to the MATLAB path.
 
Reference to non-existent field 'sensors'.
 
'lead_field_matrix' is not found in the current folder or on the MATLAB path, but exists in:
    /media/datadisk/joonas/zeffiro_interface-master/m
    /media/datadisk/joonas/zeffiro_interface-Current/m

Change the MATLAB current folder or add its folder to the MATLAB path.
 
Reference to non-existent field 'source_positions'.
 
Reference to non-existent field 'source_interpolation_ind'.
 
Reference to non-existent field 'L'.
 
Error using save
Variable 's_ind_1' not found.
 
'zef_save_nodisplay' is not found in the current folder or on the MATLAB path, but exists in:
    /media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools
    /media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools

Change the MATLAB current folder or add its folder to the MATLAB path.
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cat joonas_make_all.m 
run('../../../zeffiro_interface_nodisplay');

zef.file_path = [zef.program_path '/data/'];
zef.file = 'sphere_15kS_1mmMr.mat';

zef_load_nodisplay;

zef.gpu_num = 2;
zef.use_gpu = 1;

zef.source_interpolation_on = 1; 
set(zef.h_source_interpolation_on,'value',1); 
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]); 
[zef.nodes,zef.nodes_b,zef.tetra,zef.sigma_ind,zef.surface_triangles]=fem_mesh([]);
zef.tetra_aux = zef.tetra; 
[zef.sigma,zef.brain_ind,zef.non_source_ind,zef.nodes,zef.tetra,zef.sigma_prisms,zef.prisms,zef.submesh_ind]=zef_sigma([]); 
zef.n_sources_mod = 1; 
zef.source_ind = []; 
set(zef.h_text_elements,'string',num2str(size(zef.tetra,1)+size(zef.prisms,1))); 
set(zef.h_text_nodes,'string',num2str(size(zef.nodes,1)));
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]);
[zef.sensors_attached_volume] = attach_sensors_volume(zef.sensors);
lead_field_matrix;

source_positions = zef.source_positions;
[s_ind_1] = unique(zef.source_interpolation_ind{1});
L = zef.L;
save('SphereSpace.mat','s_ind_1','L','source_positions');

zef.file = 'sphere_15kS_1mmMr.mat';

zef.save_switch = 7;
zef_save_nodisplay;
exit;sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cat joonas_make_all.m 
run('../../../zeffiro_interface_nodisplay');

zef.file_path = [zef.program_path '/data/'];
zef.file = 'sphere_15kS_1mmMr.mat';

zef_load_nodisplay;

zef.gpu_num = 2;
zef.use_gpu = 1;

zef.source_interpolation_on = 1; 
set(zef.h_source_interpolation_on,'value',1); 
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]); 
[zef.nodes,zef.nodes_b,zef.tetra,zef.sigma_ind,zef.surface_triangles]=fem_mesh([]);
zef.tetra_aux = zef.tetra; 
[zef.sigma,zef.brain_ind,zef.non_source_ind,zef.nodes,zef.tetra,zef.sigma_prisms,zef.prisms,zef.submesh_ind]=zef_sigma([]); 
zef.n_sources_mod = 1; 
zef.source_ind = []; 
set(zef.h_text_elements,'string',num2str(size(zef.tetra,1)+size(zef.prisms,1))); 
set(zef.h_text_nodes,'string',num2str(size(zef.nodes,1)));
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]);
[zef.sensors_attached_volume] = attach_sensors_volume(zef.sensors);
lead_field_matrix;

source_positions = zef.source_positions;
[s_ind_1] = unique(zef.source_interpolation_ind{1});
L = zef.L;
save('SphereSpace.mat','s_ind_1','L','source_positions');

zef.file = 'sphere_15kS_1mmMr.mat';

zef.save_switch = 7;
zef_save_nodisplay;
exit;sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cat zef_error.txt 
Error using run (line 66)
../../../zeffiro_interface_nodisplay not found.
 
Unable to resolve the name zef.program_path.
 
'zef_load_nodisplay' is not found in the current folder or on the MATLAB path, but exists in:
    /media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools
    /media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools

Change the MATLAB current folder or add its folder to the MATLAB path.
 
Reference to non-existent field 'h_source_interpolation_on'.
 
'process_meshes' is not found in the current folder or on the MATLAB path, but exists in:
    /media/datadisk/joonas/zeffiro_interface-master/m
    /media/datadisk/joonas/zeffiro_interface-Current/m

Change the MATLAB current folder or add its folder to the MATLAB path.
 
'fem_mesh' is not found in the current folder or on the MATLAB path, but exists in:
    /media/datadisk/joonas/zeffiro_interface-master/m
    /media/datadisk/joonas/zeffiro_interface-Current/m

Change the MATLAB current folder or add its folder to the MATLAB path.
 
Reference to non-existent field 'tetra'.
 
'zef_sigma' is not found in the current folder or on the MATLAB path, but exists in:
    /media/datadisk/joonas/zeffiro_interface-master/m
    /media/datadisk/joonas/zeffiro_interface-Current/m

Change the MATLAB current folder or add its folder to the MATLAB path.
 
Reference to non-existent field 'h_text_elements'.
 
Reference to non-existent field 'h_text_nodes'.
 
'process_meshes' is not found in the current folder or on the MATLAB path, but exists in:
    /media/datadisk/joonas/zeffiro_interface-master/m
    /media/datadisk/joonas/zeffiro_interface-Current/m

Change the MATLAB current folder or add its folder to the MATLAB path.
 
Reference to non-existent field 'sensors'.
 
'lead_field_matrix' is not found in the current folder or on the MATLAB path, but exists in:
    /media/datadisk/joonas/zeffiro_interface-master/m
    /media/datadisk/joonas/zeffiro_interface-Current/m

Change the MATLAB current folder or add its folder to the MATLAB path.
 
Reference to non-existent field 'source_positions'.
 
Reference to non-existent field 'source_interpolation_ind'.
 
Reference to non-existent field 'L'.
 
Error using save
Variable 's_ind_1' not found.
 
'zef_save_nodisplay' is not found in the current folder or on the MATLAB path, but exists in:
    /media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools
    /media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools

Change the MATLAB current folder or add its folder to the MATLAB path.
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cat script_zef_make_all.m 
run('../../../zeffiro_interface_nodisplay');

zef.file_path = [zef.program_path '/data/'];
zef.file = 'sphere_example.mat';

zef_load_nodisplay;

zef.gpu_num = 2;
zef.use_gpu = 1;

zef_make_all_nodisplay;

zef.file = 'sphere_example.mat';
zef.save_switch = 7;
zef_save_nodisplay;

exit;
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cat joonas_make_all.m 
run('../../../zeffiro_interface_nodisplay');

zef.file_path = [zef.program_path '/data/'];
zef.file = 'sphere_15kS_1mmMr.mat';

zef_load_nodisplay;

zef.gpu_num = 2;
zef.use_gpu = 1;

zef.source_interpolation_on = 1; 
set(zef.h_source_interpolation_on,'value',1); 
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]); 
[zef.nodes,zef.nodes_b,zef.tetra,zef.sigma_ind,zef.surface_triangles]=fem_mesh([]);
zef.tetra_aux = zef.tetra; 
[zef.sigma,zef.brain_ind,zef.non_source_ind,zef.nodes,zef.tetra,zef.sigma_prisms,zef.prisms,zef.submesh_ind]=zef_sigma([]); 
zef.n_sources_mod = 1; 
zef.source_ind = []; 
set(zef.h_text_elements,'string',num2str(size(zef.tetra,1)+size(zef.prisms,1))); 
set(zef.h_text_nodes,'string',num2str(size(zef.nodes,1)));
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]);
[zef.sensors_attached_volume] = attach_sensors_volume(zef.sensors);
lead_field_matrix;

source_positions = zef.source_positions;
[s_ind_1] = unique(zef.source_interpolation_ind{1});
L = zef.L;
save('SphereSpace.mat','s_ind_1','L','source_positions');

zef.file = 'sphere_15kS_1mmMr.mat';

zef.save_switch = 7;
zef_save_nodisplay;
exit;sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ cd ..
sampsa@herique:/media/datadisk/joonas$ cd ..
sampsa@herique:/media/datadisk$ chmod 777 -R joonas
chmod: changing permissions of 'joonas': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master.zip': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/zeffiro_interface.ini': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/mlapp/zeffiro_interface_lf_bank_tool.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/zef_lf_bank_update_noise_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/zef_combine_lead_fields.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/zef_lf_bank_compute_lead_fields.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/zef_lf_bank_update_measurements.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/lead_field_normalization_functions': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_whitening.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/lead_field_normalization_functions/koe': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_normalize_mean_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_no_normalization.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_normalize_maximum_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_normalize_frobenius.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/zef_delete_lf_item.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/zef_lf_bank_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/zef_init_lf_bank_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/zef_add_lf_item.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/LFBankTool/m/zef_update_lf_bank_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroTopography': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroTopography/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroTopography/m/zef_evaluate_topography.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroTopography/m/zef_topography.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroTopography/m/zef_update_topography.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroTopography/m/zef_init_topography.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroTopography/fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroTopography/fig/zeffiro_interface_topography.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/HBSampler': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/HBSampler/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/HBSampler/m/mcmc_sampler.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/HBSampler/m/hb_sampler.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/HBSampler/m/zef_init_hb_sampler.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/HBSampler/m/gibbs_sampler.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/HBSampler/m/zef_update_hb_sampler.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/HBSampler/fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/HBSampler/fig/hb_sampler.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/mlapp/zeffiro_interface_filter_tool.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_delete_filter_item.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_load_epoch_points.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_move_up_filter_item.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_filter_substitute_noise_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_filter_load.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_filter_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_update_filter_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_filter_save_processed_data_as.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/filter_bank': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/filter_bank/zef_ellip_band_stop_filter.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/filter_bank/zef_zero_reference.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/filter_bank/zef_ellip_high_pass_filter.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/filter_bank/zef_simple_downsampling_filter.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/filter_bank/zef_define_time_interval.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/filter_bank/zef_threshold_epoching.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/filter_bank/zef_manual_epoching.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/filter_bank/zef_exclude_channels.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/filter_bank/zef_ellip_low_pass_filter.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/filter_bank/zef_simple_ica_cleaning.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/filter_bank/zef_select_channels.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/filter_bank/zef_constant_epoching.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_init_filter_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_filter_reset.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_move_down_filter_item.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_import_raw_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_filter_save_as.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_filter_substitute_raw_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_filter_substitute_measurement_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_filter_plot_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_filter_raw_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_filter_schroll_bar.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/ZeffiroFilterTool/m/zef_add_filter_item.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/RAMUSSampler': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/RAMUSSampler/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/RAMUSSampler/m/ramus_sampler.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/RAMUSSampler/m/zef_init_ramus_sampler.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/RAMUSSampler/m/ramus_sampling_process.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/RAMUSSampler/m/zef_update_ramus_sampler.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/RAMUSSampler/fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/plugins/RAMUSSampler/fig/ramus_sampler.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_update_ias.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_parcellation_reset.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_plot_roi.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/ias_map_estimation_multires.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_sigma.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/make_eit_dec.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_update_ias_multires.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/lead_field_meg_grad_fem.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/fem_mesh.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/additional_options.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_update_options.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_plot_source.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_figure_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_mesh_tool_switch.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/print_meshes.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/merge_lead_field.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_parcellation_time_series.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/ias_iteration_multires.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/switch_onoff.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_start_new_project.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_update_ias_roi.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_init_ias.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_mesh_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_import_project.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_error.txt': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/command_line_tools': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/command_line_tools/zeffiro_interface_nodisplay.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/command_line_tools/zef_save_nodisplay.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/command_line_tools/zef_load_nodisplay.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/command_line_tools/zef_make_all_nodisplay.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/command_line_tools/scripts': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/command_line_tools/scripts/joonas_make_all.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/command_line_tools/scripts/zef_error.txt': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/command_line_tools/scripts/script_zef_make_all.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/command_line_tools/scripts/zef_out.txt': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_update_mesh_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/ias_map_estimation_roi.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/make_multires_dec.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_save.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/switch_color.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_update.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_load.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_import_segmentation.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/source_interpolation.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/plot_meshes.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_close_figs.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_get_mesh.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/synthetic_eit_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_init.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_import.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_init_options.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_find_source.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_import_parcellation_colortable.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/lead_field_eeg_fem.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_update_find_synthetic_eit_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_parcellation_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_plugin.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/ias_iteration.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/apply_transform.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_init_find_synthetic_eit_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_update_parcellation.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_update_fig_details.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_import_parcellation_points.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/compute_eit_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_init_ias_roi.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_make_butterfly_plot.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_update_fss.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_close_tools.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_inv_import.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/ias_map_estimation.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_out.txt': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_corr_no_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_corr_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_max_energy_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_corr_max_scaling_max_weighting.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_dtw_no_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_max_energy_max_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_std_no_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_cov_max_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_mean_energy_no_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_mean_energy_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_std_max_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_std_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_cov_no_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_mean_energy_max_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_cov_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_dtw_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_corr_max_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_dtw_max_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_max_energy_no_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/time_series_tools/zef_corr_mean_scaling_mean_weighting.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_butterfly_plot.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_init_butterfly_plot.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_smooth_surface.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_plot_parcellation_time_series.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/smooth_field.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/tetra_in_compartment.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_init_fss.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_figure_window.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/lead_field_meg_fem.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/process_meshes.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_import_asc.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/find_synthetic_source.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_update_butterfly_plot.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/lead_field_eit_fem.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/plot_volume.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_parcellation_default.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/lead_field_matrix.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/update_source_positions.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_init_ias_multires.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/color_label.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/find_synthetic_eit_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/attach_sensors_volume.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_parcellation_interpolation.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_pushbutton_switch.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/ias_iteration_roi.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/m/zef_init_parcellation.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/fig/ias_map_estimation_multires.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/fig/find_synthetic_source.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/fig/zeffiro_interface_figure_tool.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/fig/zeffiro_interface_segmentation_tool.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/fig/zeffiro_small_logo.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/fig/zeffiro_interface_parcellation_tool.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/fig/zeffiro_logo.jpg': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/fig/additional_options.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/fig/zeffiro_interface_mesh_tool.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/fig/ias_map_estimation.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/fig/ias_map_estimation_roi.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/fig/zeffiro_interface.jpg': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/fig/find_synthetic_eit_data.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/fig/zeffiro_interface_butterfly_plot.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/LICENSE': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/media': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/media/rec_1_surf.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/media/eit_reconstruction.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/media/time_lapse.avi': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/media/rec_1_vol_cut_1.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/media/aivokuva.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/media/parcellation_tool.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/media/parcellation_brain.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/media/rec_1_vol_cut.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/media/surface_meshes.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/media/volume_mesh.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/media/eit_model.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/media/rec_1_vol_cut_2.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/media/parcellation_correlation.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/media/cem_electrodes.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/eeg_1mm_project_settings.mat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/sphere_example.mat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/sphere_15kS_1mmMr.mat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/export_and_import_scripts': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/export_and_import_scripts/multi_lead_field_project': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/export_and_import_scripts/multi_lead_field_project/electrodes.zef': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/export_and_import_scripts/multi_lead_field_project/segmentation.zef': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/export_and_import_scripts/multi_lead_field_project/import_multi_lead_field_project.zef': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/export_and_import_scripts/multi_lead_field_project/magnetometers.zef': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/export_and_import_scripts/multi_lead_field_project/gradiometers.zef': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/export_and_import_scripts/import_segmentation.zef': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/export_and_import_scripts/fs2zef.sh': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/sensors.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/segmentation_import_example': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/segmentation_import_example/rh_white.asc': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/segmentation_import_example/outer_skull_points.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/segmentation_import_example/outer_skin_triangles.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/segmentation_import_example/lh_white.asc': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/segmentation_import_example/rh_CerebellumCortex.asc': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/segmentation_import_example/import_segmentation_ASCII.zef': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/segmentation_import_example/outer_skin_points.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/segmentation_import_example/inner_skull_triangles.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/segmentation_import_example/cem_electrodes.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/segmentation_import_example/rh_pial.asc': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/segmentation_import_example/lh_CerebellumCortex.asc': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/segmentation_import_example/lh_pial.asc': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/segmentation_import_example/outer_skull_triangles.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/segmentation_import_example/inner_skull_points.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/data/directions.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/zeffiro_plugins.ini': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/README.md': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/sphere_15kS_1mmMr.mat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-master/zeffiro_interface.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/zeffiro_interface_nodisplay.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/mlapp/zeffiro_interface_mesh_visualization_tool_app.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/mlapp/zeffiro_interface_mesh_tool_app.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/mlapp/zeffiro_interface_segmentation_tool_app.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/mlapp/zeffiro_interface_additional_options_app.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/zeffiro_interface.ini': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/DipoleScan': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/DipoleScan/zef_dipole_start.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/DipoleScan/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/DipoleScan/m/zef_dipoleScan.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/DipoleScan/debug.log': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/DipoleScan/dipole_app.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ClassicalSparseMethods': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ClassicalSparseMethods/README': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ClassicalSparseMethods/CSM_app.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ClassicalSparseMethods/CSM_app_start.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ClassicalSparseMethods/zef_CSM_iteration.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASROIInversion': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASROIInversion/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASROIInversion/m/zef_update_ias_roi.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASROIInversion/m/ias_map_estimation_roi.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASROIInversion/m/zef_switch_roi_mode.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASROIInversion/m/zef_init_ias_roi.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASROIInversion/m/zef_iasroi_plot_roi.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASROIInversion/m/ias_iteration_roi.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASROIInversion/fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASROIInversion/fig/ias_map_estimation_roi.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/mlapp/zeffiro_interface_lf_bank_tool.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/zef_lf_bank_update_noise_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/zef_combine_lead_fields.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/zef_lf_bank_compute_lead_fields.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/zef_lf_bank_update_measurements.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/lead_field_normalization_functions': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_whitening.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_whitening_diagonal_identity.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_normalize_mean_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_no_normalization.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_normalize_maximum_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/lead_field_normalization_functions/zef_lead_field_normalize_frobenius.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/zef_delete_lf_item.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/zef_lf_bank_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/zef_init_lf_bank_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/zef_add_lf_item.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LFBankTool/m/zef_update_lf_bank_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroTopography': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroTopography/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroTopography/m/zef_evaluate_topography.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroTopography/m/zef_topography.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroTopography/m/zef_update_topography.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroTopography/m/zef_init_topography.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroTopography/fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroTopography/fig/zeffiro_interface_topography.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/README': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_ias_multires': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_ias_multires/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_ias_multires/m/exp_ias_iteration_multires.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_ias_multires/m/exp_ias_map_estimation_multires.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_ias_multires/m/zef_update_exp_ias_multires.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_ias_multires/m/zef_init_exp_ias_multires.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_ias_multires/fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_ias_multires/fig/exp_ias_map_estimation_multires.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_em_multires': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_em_multires/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_em_multires/m/zef_init_exp_em_multires.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_em_multires/m/exp_em_iteration_multires.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_em_multires/m/exp_em_map_estimation_multires.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_em_multires/m/zef_update_exp_em_multires.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_em_multires/fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_em_multires/fig/exp_em_map_estimation_multires.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_em': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_em/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_em/m/exp_em_map_estimation.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_em/m/exp_em_iteration.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_em/m/zef_update_exp_em.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_em/m/zef_init_exp_em.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_em/fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_em/fig/exp_em_map_estimation.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/common': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/common/exp_make_multires_dec.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/common/L1_optimization.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/common/EM_Lasso.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_ias': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_ias/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_ias/m/exp_ias_iteration.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_ias/m/zef_update_exp_ias.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_ias/m/exp_ias_map_estimation.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_ias/m/zef_init_exp_ias.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_ias/fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/EXP/exp_ias/fig/exp_ias_map_estimation.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ReconstructionTool': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ReconstructionTool/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ReconstructionTool/m/zef_reconstructionTool_replace.asv': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ReconstructionTool/m/zef_reconstructionTool_apply.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ReconstructionTool/m/zef_reconstructionTool_refresh.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ReconstructionTool/m/zef_reconstructionTool_import.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ReconstructionTool/m/zef_reconstructionTool_addCurrent2bank.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ReconstructionTool/m/apply_functions': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ReconstructionTool/m/apply_functions/zef_reconstructionTool_power.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ReconstructionTool/m/apply_functions/zef_reconstructionTool_mean.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ReconstructionTool/m/zef_reconstructionTool_replace.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ReconstructionTool/m/zef_reconstructionTool_apply.asv': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ReconstructionTool/m/zef_reconstructionTool_delete.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ReconstructionTool/zef_reconstructionTool_app.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ReconstructionTool/zef_reconstructionTool_start.asv': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ReconstructionTool/zef_reconstructionTool_start.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/GMMClustering': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/GMMClustering/GMMclustering_app.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/GMMClustering/README': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/GMMClustering/GMMclustering_start.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/GMMClustering/zef_GMMcluster.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/GMMClustering/zef_PlotGMMcluster.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/HBSampler': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/HBSampler/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/HBSampler/m/mcmc_sampler.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/HBSampler/m/hb_sampler.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/HBSampler/m/zef_init_hb_sampler.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/HBSampler/m/gibbs_sampler.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/HBSampler/m/zef_update_hb_sampler.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/HBSampler/fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/HBSampler/fig/hb_sampler.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/PlotMeshesProto': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/PlotMeshesProto/plot_meshes_proto.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/PlotMeshesProto/zef_3D_plot_specs.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/MNETool': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/MNETool/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/MNETool/m/zef_find_mne_reconstruction.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/MNETool/m/zef_minimum_norm_estimation.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/MNETool/m/zef_update_mne.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/MNETool/m/zef_init_mne.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/MNETool/fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/MNETool/fig/zef_mne_tool.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASInversion': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASInversion/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASInversion/m/zef_update_ias.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASInversion/m/zef_init_ias.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASInversion/m/ias_iteration.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASInversion/m/ias_map_estimation.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASInversion/fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/IASInversion/fig/ias_map_estimation.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/mlapp/zef_ES_optimization_app.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/others': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/others/red_wrong_mark.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/others/green_check_mark.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_error_criteria.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_clear_plot_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_optimization_update.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_update_reconstruction.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_find_currents.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_plot_barplot.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_clear_plot_data.asv': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_find_parameters.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_optimize_current.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_4x1_fun.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_objective_function.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_rwnnz.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_optimization.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_plot_barplot_window.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_plot_error_chart.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_plot_error_chart_mouseclick.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_score_sys.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_4x1_sensors.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_plot_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_update_plot_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_plot_current_pattern.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroESWorkbench/m/zef_ES_optimization_init.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/mlapp/zeffiro_interface_filter_tool.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_delete_filter_item.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_load_epoch_points.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_move_up_filter_item.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_substitute_noise_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_load.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_update_filter_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_save_processed_data_as.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_ellip_band_stop_filter.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_zero_reference.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_ellip_high_pass_filter.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_simple_downsampling_filter.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_define_time_interval.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_threshold_epoching.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_manual_epoching.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_exclude_channels.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_ellip_low_pass_filter.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_simple_ica_cleaning.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_select_channels.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/filter_bank/zef_constant_epoching.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_init_filter_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_reset.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_move_down_filter_item.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_import_raw_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_save_as.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_substitute_raw_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_substitute_measurement_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_plot_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_raw_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_filter_schroll_bar.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/ZeffiroFilterTool/m/zef_add_filter_item.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/RAMUSSampler': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/RAMUSSampler/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/RAMUSSampler/m/ramus_sampler.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/RAMUSSampler/m/zef_init_ramus_sampler.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/RAMUSSampler/m/ramus_sampling_process.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/RAMUSSampler/m/zef_update_ramus_sampler.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/RAMUSSampler/fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/RAMUSSampler/fig/ramus_sampler.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/FindSyntheticSource': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/FindSyntheticSource/mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/FindSyntheticSource/mlapp/find_synthetic_source_app.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/FindSyntheticSource/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/FindSyntheticSource/m/zef_plot_source_intensity.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/FindSyntheticSource/m/zef_generate_time_sequence.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/FindSyntheticSource/m/zef_plot_source.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/FindSyntheticSource/m/add_synthetic_source.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/FindSyntheticSource/m/zef_find_source.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/FindSyntheticSource/m/zef_update_fss.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/FindSyntheticSource/m/find_synthetic_source.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/FindSyntheticSource/m/remove_synthetic_source.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/MUSIC': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/MUSIC/README': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/MUSIC/MUSIC_app.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/MUSIC/MUSIC_iteration.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/MUSIC/MUSIC_app_start.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/Beamformer': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/Beamformer/README': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/Beamformer/zef_beamformer_start.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/Beamformer/zef_beamformer.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/Beamformer/beamformer_app.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/RAMUSInversion': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/RAMUSInversion/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/RAMUSInversion/m/zef_ramus_inversion_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/RAMUSInversion/m/zef_ramus_iteration.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/RAMUSInversion/m/zef_init_ramus_inversion_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/RAMUSInversion/m/zef_update_ramus_inversion_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/RAMUSInversion/fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/RAMUSInversion/fig/zeffiro_interface_ramus_inversion_tool.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/readme.txt': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_mag2Grad.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_delete.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadFieldProcessingTool_aux2bank_bankPosition.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadFieldProcessingTool_aux2bank_new.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_aux2current.asv': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_aux2current.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_loadTra.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadFieldProcessingTool_add.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_BankTableLabelUpdate.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadFieldProcessingTool_addCurrentData2bank.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_updateTable.asv': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_bank2aux_bank2auxIndex.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_combine.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_delete.asv': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/m/zef_LeadfieldProcessingTool_updateTable.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/LeadFieldProcessingTool_start.asv': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/LeadFieldProcessingTool_start.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/plugins/LeadFieldProcessingTool/LeadFieldProcessingTool_app.mlapp': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_parcellation_reset.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_plot_roi.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_sigma.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_gamma_gpu.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/make_eit_dec.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_set_color.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zeffiro_interface_mesh_visualization_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_import_sensor_names.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_update_parameters.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_toggle_lock_transforms_on.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_add_sensor_name.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/lead_field_meg_grad_fem.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/fem_mesh.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_update_transform_parameters.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/additional_options.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_update_options.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/auxiliary_scripts': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/auxiliary_scripts/getElectrodePositions.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/auxiliary_scripts/getMagnetometerPositions.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_plot_source.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_figure_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_callbackpause.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_mesh_tool_switch.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/print_meshes.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/lead_field_tes_fem.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/merge_lead_field.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_compartment_table_selection.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_parcellation_time_series.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/switch_onoff.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_intensity_1_colormap.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_start_new_project.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_init_sensors_name_table.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_init_sensor_parameters.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_get_surface_mesh.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_mesh_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_import_project.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_add_sensors.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_slidding_callback.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/command_line_tools': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/command_line_tools/zeffiro_interface_nodisplay.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/command_line_tools/zef_save_nodisplay.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/command_line_tools/zef_load_nodisplay.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/command_line_tools/zef_make_all_nodisplay.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/command_line_tools/scripts': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/command_line_tools/scripts/script_zef_make_all.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_update_mesh_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_create_sensors.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_import_surface_mesh_type.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_init_transform_parameters.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_delete_original_surface_meshes.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_create_compartment.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/make_multires_dec.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_save.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_toggle_lock_sensor_names_on.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_get_sensor_points.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_delete_sensors.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/switch_color.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_delete_sensor_sets.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_update.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_update_sensors_name_table.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_load.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_import_segmentation.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/source_interpolation.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/plot_meshes.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_add_compartment.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_close_figs.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_get_mesh.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/synthetic_eit_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_change_size_function.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_get_relative_size.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_init.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_field_downsampling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_import.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zeffiro_interface_segmentation_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_callbackstop.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_find_ig_hyperprior_scale.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_toggle_lock_sensor_sets_on.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_intensity_2_colormap.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_init_options.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_find_source.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_blue_brain_1_colormap.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_add_transform.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_import_parcellation_colortable.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_set_sensor_color.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_create_sensors.asv': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_init_sensors.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/lead_field_eeg_fem.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_delete_original_field.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_exclude_load_fields.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_init_sensors_table.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zeffiro_interface_figure_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_update_find_synthetic_eit_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_update_transform.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_parcellation_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_find_ig_hyperprior.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_plugin.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_transform_table_selection.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_toggle_lock_on.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_determinant.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_visualize_volume.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_plot_hyperprior.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/apply_transform.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_get_sensor_directions.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_init_find_synthetic_eit_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_blue_brain_2_colormap.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_update_transform.asv': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_sensors_table_selection.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_contrast_5_colormap.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_update_parcellation.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_remove_object_fields.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_update_fig_details.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_import_parcellation_points.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/compute_eit_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_make_butterfly_plot.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_downsample_surfaces.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_find_g_hyperprior.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_update_fss.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_reopen_segmentation_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_init_transform.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_update_mesh_visualization_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_contrast_2_colormap.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_close_tools.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_inv_import.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_corr_no_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_corr_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_max_energy_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_corr_max_scaling_max_weighting.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_dtw_no_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_max_energy_max_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_std_no_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_cov_max_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_mean_energy_no_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_mean_energy_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_std_max_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_std_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_cov_no_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_mean_energy_max_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_cov_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_dtw_mean_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_corr_max_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_dtw_max_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_max_energy_no_scaling.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_corr_mean_scaling_mean_weighting.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/time_series_tools/zef_time_series_plot.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_inverse_gamma_gpu.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_butterfly_plot.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_init_butterfly_plot.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_monterosso_colormap.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_contrast_1_colormap.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_smooth_surface.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_plot_parcellation_time_series.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_visualize_surfaces.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/smooth_field.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_build_compartment_table.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/tetra_in_compartment.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_init_fss.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_figure_window.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/lead_field_meg_fem.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_update.asv': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_contrast_3_colormap.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_set_compartment_color.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/process_meshes.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_sensors_name_table_selection.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_import_asc.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/find_synthetic_source.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_update_butterfly_plot.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/lead_field_eit_fem.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_snapshot_movie.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/plot_volume.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_contrast_4_colormap.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_init_compartments.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_delete_compartment.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_intensity_3_colormap.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_find_g_hyperprior_ig.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_find_g_hyperprior_scale.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/inflate_surface.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_parcellation_default.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/lead_field_matrix.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/update_source_positions.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_find_gaussian_prior.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/color_label.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zeffiro_interface_mesh_tool.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/inverse_data_processing': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/inverse_data_processing/zef_processLeadfields.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/inverse_data_processing/zef_normalizeInverseReconstruction.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/inverse_data_processing/zef_getTimeStep.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/inverse_data_processing/zef_getFilteredData.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/inverse_data_processing/zef_postProcessInverse.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zeffiro_interface_additional_options.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/find_synthetic_eit_data.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/attach_sensors_volume.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_delete_transform.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_parcellation_interpolation.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_pushbutton_switch.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_blue_brain_3_colormap.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_init_parcellation.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_update_system_information.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/m/zef_parcellation_colormap.m': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/fig/zeffiro_interface_ramus_inversion_tool.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/fig/find_synthetic_source.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/fig/zeffiro_logo.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/fig/zeffiro_interface_figure_tool.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/fig/zeffiro_interface_segmentation_tool.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/fig/zeffiro_small_logo.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/fig/zeffiro_interface_parcellation_tool.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/fig/additional_options.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/fig/zeffiro_interface_mesh_tool.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/fig/zeffiro_interface.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/fig/find_synthetic_eit_data.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/fig/zeffiro_interface_butterfly_plot.fig': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/LICENSE': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/media': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/media/rec_1_surf.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/media/eit_reconstruction.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/media/time_lapse.avi': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/media/rec_1_vol_cut_1.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/media/aivokuva.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/media/parcellation_tool.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/media/parcellation_brain.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/media/rec_1_vol_cut.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/media/surface_meshes.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/media/volume_mesh.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/media/eit_model.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/media/rec_1_vol_cut_2.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/media/parcellation_correlation.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/media/cem_electrodes.png': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/eeg_1mm_project_settings.mat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/sphere_example.mat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/export_and_import_scripts': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/export_and_import_scripts/multi_lead_field_project': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/export_and_import_scripts/multi_lead_field_project/electrodes.zef': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/export_and_import_scripts/multi_lead_field_project/segmentation.zef': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/export_and_import_scripts/multi_lead_field_project/import_multi_lead_field_project.zef': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/export_and_import_scripts/multi_lead_field_project/magnetometers.zef': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/export_and_import_scripts/multi_lead_field_project/gradiometers.zef': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/export_and_import_scripts/import_segmentation.zef': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/export_and_import_scripts/fs2zef.sh': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/sensors.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/segmentation_import_example': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/segmentation_import_example/rh_white.asc': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/segmentation_import_example/outer_skull_points.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/segmentation_import_example/outer_skin_triangles.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/segmentation_import_example/lh_white.asc': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/segmentation_import_example/rh_CerebellumCortex.asc': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/segmentation_import_example/import_segmentation_ASCII.zef': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/segmentation_import_example/outer_skin_points.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/segmentation_import_example/inner_skull_triangles.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/segmentation_import_example/cem_electrodes.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/segmentation_import_example/rh_pial.asc': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/segmentation_import_example/lh_CerebellumCortex.asc': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/segmentation_import_example/lh_pial.asc': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/segmentation_import_example/outer_skull_triangles.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/segmentation_import_example/inner_skull_points.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/data/directions.dat': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/zeffiro_plugins.ini': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/README.md': Operation not permitted
chmod: changing permissions of 'joonas/zeffiro_interface-Current/zeffiro_interface.m': Operation not permitted
sampsa@herique:/media/datadisk$ sudo chmod 777 -R joonas
sampsa@herique:/media/datadisk$ sudo chown -R joonaslahtinen joonas
sampsa@herique:/media/datadisk$ cd joonas/
sampsa@herique:/media/datadisk/joonas$ cd zeffiro_interface-master/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ ls
LICENSE    command_line_tools  fig  plugins                zeffiro_interface.ini  zeffiro_plugins.ini
README.md  data                m    sphere_15kS_1mmMr.mat  zeffiro_interface.m
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ cd command_line_tools/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools$ ls
scripts  zef_load_nodisplay.m  zef_make_all_nodisplay.m  zef_save_nodisplay.m  zeffiro_interface_nodisplay.m
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools$ cd scripts/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ ls
joonas_make_all.m  script_zef_make_all.m  zef_error.txt  zef_out.txt
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ nohup matlab -nodesktop -nodisplay -nosplash < joonas_make_all.m 1>zef_out.txt 2>zef_error.txt &
[1] 22966
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ top

top - 18:03:59 up  1:54,  3 users,  load average: 0,17, 0,08, 0,09
Tasks: 580 total,   1 running, 579 sleeping,   0 stopped,   0 zombie
%Cpu(s):  3,2 us,  0,1 sy,  0,0 ni, 96,7 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 123169,1 free,   2649,8 used,   2725,7 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 124589,3 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
  22966 sampsa    20   0 9975052   1,0g 290356 S  65,6   0,8   0:21.03 MATLAB                                                                
  23988 root      20   0   13264   8024   6904 S   1,0   0,0   0:00.03 sshd                                                                  
   4365 joonasl+  20   0  234472 111520  53560 S   0,7   0,1   0:45.79 Xtightvnc                                                             
  10746 joonasl+  20   0  967256  53200  40472 S   0,7   0,0   0:03.78 gnome-terminal-                                                       
  23702 sampsa    20   0   17004   4648   3544 R   0,7   0,0   0:00.06 top                                                                   
   4460 joonasl+  20   0  881044  76580  62144 S   0,3   0,1   0:02.03 gnome-flashback                                                       
   4554 joonasl+  20   0  313812   8380   6900 S   0,3   0,0   0:01.68 ibus-daemon                                                           
   4586 joonasl+  20   0  165564   7216   6584 S   0,3   0,0   0:00.69 ibus-engine-sim                                                       
  10152 joonasl+  20   0   14124   6040   4548 S   0,3   0,0   0:07.43 sshd                                                                  
      1 root      20   0  167996  11812   8304 S   0,0   0,0   0:03.24 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:08.47 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.07 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.61 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.72 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.69 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
[1]+  Done                    nohup matlab -nodesktop -nodisplay -nosplash < joonas_make_all.m > zef_out.txt 2> zef_error.txt
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ cat zef_error.txt 
Error using run (line 66)
../../../zeffiro_interface_nodisplay not found.
 
Unable to resolve the name zef.program_path.
 
Unrecognized function or variable 'zef_load_nodisplay'.
 
Reference to non-existent field 'h_source_interpolation_on'.
 
Unrecognized function or variable 'process_meshes'.
 
Unrecognized function or variable 'fem_mesh'.
 
Reference to non-existent field 'tetra'.
 
Unrecognized function or variable 'zef_sigma'.
 
Reference to non-existent field 'h_text_elements'.
 
Reference to non-existent field 'h_text_nodes'.
 
Unrecognized function or variable 'process_meshes'.
 
Reference to non-existent field 'sensors'.
 
Unrecognized function or variable 'lead_field_matrix'.
 
Reference to non-existent field 'source_positions'.
 
Reference to non-existent field 'source_interpolation_ind'.
 
Reference to non-existent field 'L'.
 
Error using save
Variable 's_ind_1' not found.
 
Unrecognized function or variable 'zef_save_nodisplay'.
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ top

top - 18:04:13 up  1:55,  3 users,  load average: 0,13, 0,08, 0,09
Tasks: 579 total,   1 running, 578 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,3 us,  0,5 sy,  0,0 ni, 99,2 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 123908,0 free,   1910,6 used,   2725,9 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 125328,4 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
  24812 sampsa    20   0   17004   4652   3548 R  11,8   0,0   0:00.03 top                                                                   
      1 root      20   0  167996  11812   8304 S   0,0   0,0   0:03.24 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:08.48 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.07 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.61 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.72 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/7                                                           
     54 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/7                                                           
     56 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/7:0H-kblockd                                                  
     57 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/8                                                               
     58 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/8                                                         
     59 root      rt   0       0      0      0 S   0,0   0,0   0:00.65 migration/8                                                           
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ cat zef_error.txt 
Error using run (line 66)
../../../zeffiro_interface_nodisplay not found.
 
Unable to resolve the name zef.program_path.
 
Unrecognized function or variable 'zef_load_nodisplay'.
 
Reference to non-existent field 'h_source_interpolation_on'.
 
Unrecognized function or variable 'process_meshes'.
 
Unrecognized function or variable 'fem_mesh'.
 
Reference to non-existent field 'tetra'.
 
Unrecognized function or variable 'zef_sigma'.
 
Reference to non-existent field 'h_text_elements'.
 
Reference to non-existent field 'h_text_nodes'.
 
Unrecognized function or variable 'process_meshes'.
 
Reference to non-existent field 'sensors'.
 
Unrecognized function or variable 'lead_field_matrix'.
 
Reference to non-existent field 'source_positions'.
 
Reference to non-existent field 'source_interpolation_ind'.
 
Reference to non-existent field 'L'.
 
Error using save
Variable 's_ind_1' not found.
 
Unrecognized function or variable 'zef_save_nodisplay'.
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ cd command_line_tools/scripts/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ pico joonas_make_all.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ top

top - 18:11:37 up  2:02,  3 users,  load average: 0,20, 0,23, 0,16
Tasks: 582 total,   1 running, 581 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,1 us,  0,0 sy,  0,0 ni, 99,9 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 123889,5 free,   1920,9 used,   2734,2 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 125314,7 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
  30870 root      20   0   13264   8000   6880 S   1,0   0,0   0:00.03 sshd                                                                  
   4365 joonasl+  20   0  236520 112624  54664 S   0,7   0,1   0:53.41 Xtightvnc                                                             
  10746 joonasl+  20   0  967256  53200  40472 S   0,7   0,0   0:05.02 gnome-terminal-                                                       
  10152 joonasl+  20   0   14124   6040   4548 S   0,3   0,0   0:09.01 sshd                                                                  
  30869 sampsa    20   0   17004   4552   3448 R   0,3   0,0   0:00.06 top                                                                   
  30871 sshd      20   0   12184   4476   3560 S   0,3   0,0   0:00.01 sshd                                                                  
      1 root      20   0  167996  11812   8304 S   0,0   0,0   0:03.27 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:08.72 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.08 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.61 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.72 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/7                                                           
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ pico joonas_make_all.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ pico joonas_make_all.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ pico joonas_make_all.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ pico joonas_make_all.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ nohup matlab -nodesktop -nodisplay -nosplash < joonas_make_all.m 1>zef_out.txt 2>zef_error.txt &
[1] 30884
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ top

top - 18:14:03 up  2:04,  3 users,  load average: 0,59, 0,27, 0,18
Tasks: 577 total,   1 running, 576 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,7 us,  0,3 sy,  0,0 ni, 99,0 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 123891,8 free,   1918,6 used,   2734,2 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 125317,1 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
   4383 joonasl+  20   0 1702200  93784  56324 S   1,0   0,1   0:20.90 nautilus                                                              
  31663 sampsa    20   0   17004   4648   3544 R   0,7   0,0   0:00.06 top                                                                   
   1128 root      20   0  402600  23148  10244 S   0,3   0,0   0:04.86 f2b/server                                                            
      1 root      20   0  167996  11812   8304 S   0,0   0,0   0:03.27 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:08.75 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.08 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.61 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.74 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/7                                                           
     54 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/7                                                           
     56 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/7:0H-kblockd                                                  
     57 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/8                                                               
[1]+  Done                    nohup matlab -nodesktop -nodisplay -nosplash < joonas_make_all.m > zef_out.txt 2> zef_error.txt
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ cat zef_error.txt 
Error using run (line 66)
../../zeffiro_interface_nodisplay not found.
 
Unable to resolve the name zef.program_path.
 
Unrecognized function or variable 'zef_load_nodisplay'.
 
Reference to non-existent field 'h_source_interpolation_on'.
 
Unrecognized function or variable 'process_meshes'.
 
Unrecognized function or variable 'fem_mesh'.
 
Reference to non-existent field 'tetra'.
 
Unrecognized function or variable 'zef_sigma'.
 
Reference to non-existent field 'h_text_elements'.
 
Reference to non-existent field 'h_text_nodes'.
 
Unrecognized function or variable 'process_meshes'.
 
Reference to non-existent field 'sensors'.
 
Unrecognized function or variable 'lead_field_matrix'.
 
Reference to non-existent field 'source_positions'.
 
Reference to non-existent field 'source_interpolation_ind'.
 
Reference to non-existent field 'L'.
 
Error using save
Variable 's_ind_1' not found.
 
Unrecognized function or variable 'zef_save_nodisplay'.
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ top

top - 18:14:20 up  2:05,  3 users,  load average: 0,46, 0,25, 0,18
Tasks: 577 total,   1 running, 576 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,5 us,  0,5 sy,  0,0 ni, 98,9 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 123892,0 free,   1918,4 used,   2734,2 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 125317,3 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
  32722 sampsa    20   0   17004   4648   3544 R  11,8   0,0   0:00.03 top                                                                   
      1 root      20   0  167996  11812   8304 S   0,0   0,0   0:03.27 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:08.75 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.08 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.61 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.74 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/7                                                           
     54 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/7                                                           
     56 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/7:0H-kblockd                                                  
     57 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/8                                                               
     58 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/8                                                         
     59 root      rt   0       0      0      0 S   0,0   0,0   0:00.65 migration/8                                                           
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/command_line_tools/scripts$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ ls
LICENSE  README.md  data  fig  m  plugins  sphere_15kS_1mmMr.mat  zeffiro_interface.ini  zeffiro_interface.m  zeffiro_plugins.ini
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ cd m
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m$ cd command_line_tools/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools$ cd scripts/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ pico joonas_make_all.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ rm zef_error.txt 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ nohup matlab -nodesktop -nodisplay -nosplash < joonas_make_all.m 1>zef_out.txt 2>zef_error.txt &
[1] 32750
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cat zef_error.txt 
Error using run (line 66)
../../../zeffiro_interface_nodisplay not found.
 
Unable to resolve the name zef.program_path.
 
Unrecognized function or variable 'zef_load_nodisplay'.
 
Reference to non-existent field 'h_source_interpolation_on'.
 
Unrecognized function or variable 'process_meshes'.
 
Unrecognized function or variable 'fem_mesh'.
 
Reference to non-existent field 'tetra'.
 
Unrecognized function or variable 'zef_sigma'.
 
Reference to non-existent field 'h_text_elements'.
 
Reference to non-existent field 'h_text_nodes'.
 
Unrecognized function or variable 'process_meshes'.
 
Reference to non-existent field 'sensors'.
 
Unrecognized function or variable 'lead_field_matrix'.
 
Reference to non-existent field 'source_positions'.
 
Reference to non-existent field 'source_interpolation_ind'.
 
Reference to non-existent field 'L'.
 
Error using save
Variable 's_ind_1' not found.
 
Unrecognized function or variable 'zef_save_nodisplay'.
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cat script_zef_make_all.m 
run('../../../zeffiro_interface_nodisplay');

zef.file_path = [zef.program_path '/data/'];
zef.file = 'sphere_example.mat';

zef_load_nodisplay;

zef.gpu_num = 2;
zef.use_gpu = 1;

zef_make_all_nodisplay;

zef.file = 'sphere_example.mat';
zef.save_switch = 7;
zef_save_nodisplay;

exit;
[1]+  Done                    nohup matlab -nodesktop -nodisplay -nosplash < joonas_make_all.m > zef_out.txt 2> zef_error.txt
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ pico joonas_make_all.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ matlab -nodesktop
MATLAB is selecting SOFTWARE OPENGL rendering.

                                                           < M A T L A B (R) >
                                                 Copyright 1984-2020 The MathWorks, Inc.
                                             R2020b Update 1 (9.9.0.1495850) 64-bit (glnxa64)
                                                            September 30, 2020

 
To get started, type doc.
For product information, visit www.mathworks.com.
 
>> run('../../../zeffiro_interface_nodisplay');
Error using run (line 66)
../../../zeffiro_interface_nodisplay not found.
 
>> run('../../../zeffiro_interface_nodisplay') 
Error using run (line 66)
../../../zeffiro_interface_nodisplay not found.
 
>> run('../../../zeffiro_interface_nodisplay.m')
Error using run (line 68)
RUN cannot execute the file '../../../zeffiro_interface_nodisplay.m'. RUN requires a valid MATLAB script
 
>> run('./../../../zeffiro_interface_nodisplay')
Error using run (line 66)
./../../../zeffiro_interface_nodisplay not found.
 
>> run('../../zeffiro_interface_nodisplay')     
Error using run (line 66)
../../zeffiro_interface_nodisplay not found.
 
>> run('../zeffiro_interface_nodisplay.m')      
Unrecognized function or variable 'fullpath'.

Error in zeffiro_interface_nodisplay (line 17)
zef.program_path = fullpath(cd,'../../');

Error in run (line 91)
evalin('caller', strcat(script, ';'));
 
>> quit


sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ pico joonas_make_all.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ nohup matlab -nodesktop -nodisplay -nosplash < joonas_make_all.m 1>zef_out.txt 2>zef_error.txt &
[1] 36419
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cat zef_error.txt 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ top

top - 18:17:30 up  2:08,  3 users,  load average: 0,63, 0,32, 0,21
Tasks: 577 total,   1 running, 576 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,0 us,  0,0 sy,  0,0 ni, 99,9 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 123887,0 free,   1922,6 used,   2735,0 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 125313,0 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
   1049 syslog    20   0  224356   5236   3672 S   0,3   0,0   0:00.60 rsyslogd                                                              
   1128 root      20   0  402600  23148  10244 S   0,3   0,0   0:05.01 f2b/server                                                            
  37634 sampsa    20   0   17004   4556   3448 R   0,3   0,0   0:00.06 top                                                                   
      1 root      20   0  167996  11816   8304 S   0,0   0,0   0:03.28 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:08.81 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.08 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.61 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.74 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.72 migration/7                                                           
     54 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/7                                                           
     56 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/7:0H-kblockd                                                  
     57 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/8                                                               
[1]+  Done                    nohup matlab -nodesktop -nodisplay -nosplash < joonas_make_all.m > zef_out.txt 2> zef_error.txt
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cat zef_error.txt 
Unrecognized function or variable 'fullpath'.

Error in zeffiro_interface_nodisplay (line 17)
zef.program_path = fullpath(cd,'../../');

Error in run (line 91)
evalin('caller', strcat(script, ';'));
 
Reference to non-existent field 'program_path'.
 
Unrecognized function or variable 'zef_load_nodisplay'.
 
Reference to non-existent field 'h_source_interpolation_on'.
 
Unrecognized function or variable 'process_meshes'.
 
Unrecognized function or variable 'fem_mesh'.
 
Reference to non-existent field 'tetra'.
 
Unrecognized function or variable 'zef_sigma'.
 
Reference to non-existent field 'h_text_elements'.
 
Reference to non-existent field 'h_text_nodes'.
 
Unrecognized function or variable 'process_meshes'.
 
Reference to non-existent field 'sensors'.
 
Unrecognized function or variable 'lead_field_matrix'.
 
Reference to non-existent field 'source_positions'.
 
Reference to non-existent field 'source_interpolation_ind'.
 
Reference to non-existent field 'L'.
 
Error using save
Variable 's_ind_1' not found.
 
Unrecognized function or variable 'zef_save_nodisplay'.
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ pico joonas_make_all.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools$ ll
total 32
drwxrwxrwx 3 joonaslahtinen joonaslahtinen 4096 kesä   17 15:41 ./
drwxrwxrwx 4 joonaslahtinen joonaslahtinen 4096 kesä   17 18:08 ../
drwxrwxrwx 2 joonaslahtinen joonaslahtinen 4096 kesä   17 18:18 scripts/
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen  936 kesä   17 15:41 zef_load_nodisplay.m*
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen  527 kesä   17 15:41 zef_make_all_nodisplay.m*
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen 5095 kesä   17 15:41 zef_save_nodisplay.m*
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen 1596 kesä   17 15:41 zeffiro_interface_nodisplay.m*
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools$ mv zeffiro_interface_nodisplay.m ../../
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ ll
total 38440
drwxrwxrwx 6 joonaslahtinen joonaslahtinen     4096 kesä   17 18:18 ./
drwxrwxrwx 4 joonaslahtinen joonaslahtinen     4096 kesä   17 15:41 ../
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen    35210 tammi  30  2020 LICENSE*
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen     3993 tammi  30  2020 README.md*
drwxrwxrwx 5 joonaslahtinen joonaslahtinen     4096 kesä   17 17:32 data/
drwxrwxrwx 2 joonaslahtinen joonaslahtinen     4096 tammi  30  2020 fig/
drwxrwxrwx 4 joonaslahtinen joonaslahtinen     4096 kesä   17 18:08 m/
drwxrwxrwx 7 joonaslahtinen joonaslahtinen     4096 tammi  30  2020 plugins/
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen 39269513 kesä   17 16:27 sphere_15kS_1mmMr.mat*
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen      333 tammi  30  2020 zeffiro_interface.ini*
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen     9162 tammi  30  2020 zeffiro_interface.m*
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen     1596 kesä   17 15:41 zeffiro_interface_nodisplay.m*
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen     1033 tammi  30  2020 zeffiro_plugins.ini*
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ cd m
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m$ cd command_line_tools/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools$ cd scripts/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ pico joonas_make_all.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ nohup matlab -nodesktop -nodisplay -nosplash < joonas_make_all.m 1>zef_out.txt 2>zef_error.txt &
[1] 38293
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cat zef_error.txt 
Unrecognized function or variable 'fullpath'.

Error in zeffiro_interface_nodisplay (line 17)
zef.program_path = fullpath(cd,'../../');

Error in run (line 91)
evalin('caller', strcat(script, ';'));
 
Reference to non-existent field 'program_path'.
 
Unrecognized function or variable 'zef_load_nodisplay'.
 
Reference to non-existent field 'h_source_interpolation_on'.
 
Unrecognized function or variable 'process_meshes'.
 
Unrecognized function or variable 'fem_mesh'.
 
Reference to non-existent field 'tetra'.
 
Unrecognized function or variable 'zef_sigma'.
 
Reference to non-existent field 'h_text_elements'.
 
Reference to non-existent field 'h_text_nodes'.
 
Unrecognized function or variable 'process_meshes'.
 
Reference to non-existent field 'sensors'.
 
Unrecognized function or variable 'lead_field_matrix'.
 
Reference to non-existent field 'source_positions'.
 
Reference to non-existent field 'source_interpolation_ind'.
 
Reference to non-existent field 'L'.
 
Error using save
Variable 's_ind_1' not found.
 
Unrecognized function or variable 'zef_save_nodisplay'.
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ top

top - 18:19:24 up  2:10,  3 users,  load average: 0,28, 0,26, 0,19
Tasks: 577 total,   1 running, 576 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,1 us,  0,0 sy,  0,0 ni, 99,9 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 123891,7 free,   1917,5 used,   2735,4 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 125317,9 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
  40129 sampsa    20   0   17004   4492   3388 R   0,7   0,0   0:00.04 top                                                                   
    495 root      19  -1  181156  94292  91728 S   0,3   0,1   0:02.28 systemd-journal                                                       
   1022 message+  20   0   10348   7132   3948 S   0,3   0,0   0:04.88 dbus-daemon                                                           
   2104 sampsa    20   0  555524  60816  47128 S   0,3   0,0   0:01.32 unity-settings-                                                       
   4464 joonasl+  20   0  553856  60688  46956 S   0,3   0,0   0:01.46 unity-settings-                                                       
      1 root      20   0  167996  11816   8304 S   0,0   0,0   0:03.29 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:08.84 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.08 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.61 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.70 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.74 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.71 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.72 migration/7                                                           
     54 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/7                                                           
[1]+  Done                    nohup matlab -nodesktop -nodisplay -nosplash < joonas_make_all.m > zef_out.txt 2> zef_error.txt
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ pico joonas_make_all.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cat zef_error.txt 
Unrecognized function or variable 'fullpath'.

Error in zeffiro_interface_nodisplay (line 17)
zef.program_path = fullpath(cd,'../../');

Error in run (line 91)
evalin('caller', strcat(script, ';'));
 
Reference to non-existent field 'program_path'.
 
Unrecognized function or variable 'zef_load_nodisplay'.
 
Reference to non-existent field 'h_source_interpolation_on'.
 
Unrecognized function or variable 'process_meshes'.
 
Unrecognized function or variable 'fem_mesh'.
 
Reference to non-existent field 'tetra'.
 
Unrecognized function or variable 'zef_sigma'.
 
Reference to non-existent field 'h_text_elements'.
 
Reference to non-existent field 'h_text_nodes'.
 
Unrecognized function or variable 'process_meshes'.
 
Reference to non-existent field 'sensors'.
 
Unrecognized function or variable 'lead_field_matrix'.
 
Reference to non-existent field 'source_positions'.
 
Reference to non-existent field 'source_interpolation_ind'.
 
Reference to non-existent field 'L'.
 
Error using save
Variable 's_ind_1' not found.
 
Unrecognized function or variable 'zef_save_nodisplay'.
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools$ ll
total 28
drwxrwxrwx 3 joonaslahtinen joonaslahtinen 4096 kesä   17 18:18 ./
drwxrwxrwx 4 joonaslahtinen joonaslahtinen 4096 kesä   17 18:08 ../
drwxrwxrwx 2 joonaslahtinen joonaslahtinen 4096 kesä   17 18:19 scripts/
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen  936 kesä   17 15:41 zef_load_nodisplay.m*
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen  527 kesä   17 15:41 zef_make_all_nodisplay.m*
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen 5095 kesä   17 15:41 zef_save_nodisplay.m*
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ cat zeffiro_interface
cat: zeffiro_interface: No such file or directory
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ cp ../zeffiro_interface-Current/zeffiro_interface_nodisplay.m ./
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ cd m
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m$ cd command_line_tools/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools$ cd scripts/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ nohup matlab -nodesktop -nodisplay -nosplash < joonas_make_all.m 1>zef_out.txt 2>zef_error.txt &
[1] 40197
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cat zef_error.txt 
Index exceeds the number of array elements (20).

Error in zeffiro_interface_nodisplay (line 42)
zef.mlapp = str2num(zef.ini_cell{1}{22});

Error in run (line 91)
evalin('caller', strcat(script, ';'));
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cat zef_error.txt 
Index exceeds the number of array elements (20).

Error in zeffiro_interface_nodisplay (line 42)
zef.mlapp = str2num(zef.ini_cell{1}{22});

Error in run (line 91)
evalin('caller', strcat(script, ';'));
 
Reference to non-existent field 'mlapp'.

Error in zef_load_nodisplay (line 22)
zef_data.mlapp = zef.mlapp;
 
Reference to non-existent field 'h_source_interpolation_on'.
 
Index in position 2 exceeds array bounds.

Error in process_meshes (line 221)
mean_vec = repmat(mean(sensors(:,1:3)),size(sensors(:,1:3),1),1);
 
Array indices must be positive integers or logical values.

Error in fem_mesh (line 174)
x_lim = [min(reuna_p{end}(:,1)) max(reuna_p{end}(:,1))];
 
Error using sub2ind (line 51)
The subscript vectors must all be of the same size.

Error in zef_sigma (line 287)
priority_ind = sub2ind(size(johtavuus_ind),[1:size(johtavuus_ind,1)]',priority_ind);
 
Reference to non-existent field 'h_text_elements'.
 
Reference to non-existent field 'h_text_nodes'.
 
Index in position 2 exceeds array bounds.

Error in process_meshes (line 221)
mean_vec = repmat(mean(sensors(:,1:3)),size(sensors(:,1:3),1),1);
 
Index in position 2 exceeds array bounds.

Error in lead_field_matrix (line 89)
[zef.L, zef.source_positions, zef.source_directions] = lead_field_eeg_fem(zef.nodes_aux,zef.tetra,zef.sigma(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
 
Brace indexing is not supported for variables of this type.
 
Error using save
Variable 's_ind_1' not found.
 
[1]+  Done                    nohup matlab -nodesktop -nodisplay -nosplash < joonas_make_all.m > zef_out.txt 2> zef_error.txt
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cat zef_error.txt 
Index exceeds the number of array elements (20).

Error in zeffiro_interface_nodisplay (line 42)
zef.mlapp = str2num(zef.ini_cell{1}{22});

Error in run (line 91)
evalin('caller', strcat(script, ';'));
 
Reference to non-existent field 'mlapp'.

Error in zef_load_nodisplay (line 22)
zef_data.mlapp = zef.mlapp;
 
Reference to non-existent field 'h_source_interpolation_on'.
 
Index in position 2 exceeds array bounds.

Error in process_meshes (line 221)
mean_vec = repmat(mean(sensors(:,1:3)),size(sensors(:,1:3),1),1);
 
Array indices must be positive integers or logical values.

Error in fem_mesh (line 174)
x_lim = [min(reuna_p{end}(:,1)) max(reuna_p{end}(:,1))];
 
Error using sub2ind (line 51)
The subscript vectors must all be of the same size.

Error in zef_sigma (line 287)
priority_ind = sub2ind(size(johtavuus_ind),[1:size(johtavuus_ind,1)]',priority_ind);
 
Reference to non-existent field 'h_text_elements'.
 
Reference to non-existent field 'h_text_nodes'.
 
Index in position 2 exceeds array bounds.

Error in process_meshes (line 221)
mean_vec = repmat(mean(sensors(:,1:3)),size(sensors(:,1:3),1),1);
 
Index in position 2 exceeds array bounds.

Error in lead_field_matrix (line 89)
[zef.L, zef.source_positions, zef.source_directions] = lead_field_eeg_fem(zef.nodes_aux,zef.tetra,zef.sigma(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
 
Brace indexing is not supported for variables of this type.
 
Error using save
Variable 's_ind_1' not found.
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m$ cd .
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ ls
LICENSE    data  m        sphere_15kS_1mmMr.mat  zeffiro_interface.m            zeffiro_plugins.ini
README.md  fig   plugins  zeffiro_interface.ini  zeffiro_interface_nodisplay.m
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ cp ../zeffiro_interface-Current/zeffiro_interface_nodisplay.m ./
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ cat zeffiro_interface_nodisplay.m 

if not(exist('zef'))
    zef = [];
end

if isfield(zef,'h_zeffiro_window_main')
    if isvalid(zef.h_zeffiro_window_main)
        error('Another instance of Zeffiro interface already open.')
    end
end
clear zef;
zef.ver = ver;
if not(license('test','distrib_computing_toolbox')) || not(any(strcmp(cellstr(char(zef.ver.Name)), 'Parallel Computing Toolbox')))
gpuDeviceCount = 0;
end
zef = rmfield(zef, 'ver');
zef.program_path = cd; 
if not(isdeployed)
zef.code_path = '/m';
addpath(genpath([zef.program_path]));
addpath(genpath([zef.program_path '/m']));
addpath(genpath([zef.program_path '/mlapp']));
addpath([zef.program_path '/fig']);  
addpath([zef.program_path zef.code_path]); 
addpath(genpath([zef.program_path '/plugins']));
end;
zef.h_zeffiro = fopen('zeffiro_interface.ini');
zef.ini_cell = textscan(zef.h_zeffiro,'%s');
zef.save_file_path = zef.ini_cell{1}{2};
zef.save_file = zef.ini_cell{1}{4};
zef.video_codec = zef.ini_cell{1}{6};
zef.use_gpu = str2num(zef.ini_cell{1}{8});
zef.gpu_num = str2num(zef.ini_cell{1}{10});
if gpuDeviceCount > 0 & zef.use_gpu == 1
gpuDevice(zef.gpu_num);
end
zef.parallel_vectors = str2num(zef.ini_cell{1}{12});
zef.snapshot_vertical_resolution = str2num(zef.ini_cell{1}{14});
zef.snapshot_horizontal_resolution = str2num(zef.ini_cell{1}{16});
zef.movie_fps = str2num(zef.ini_cell{1}{18});
zef.font_size = str2num(zef.ini_cell{1}{20});
zef.mlapp = str2num(zef.ini_cell{1}{22});
zef = rmfield(zef,'ini_cell');

zef_data = zef;
zef_init;

zef.clear_axes1 = 0;






sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ cd data/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/data$ ll
total 38756
drwxrwxrwx 5 joonaslahtinen joonaslahtinen     4096 kesä   17 17:32 ./
drwxrwxrwx 6 joonaslahtinen joonaslahtinen     4096 kesä   17 18:18 ../
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen     4998 tammi  30  2020 directions.dat*
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen   259208 tammi  30  2020 eeg_1mm_project_settings.mat*
drwxrwxrwx 3 joonaslahtinen joonaslahtinen     4096 tammi  30  2020 export_and_import_scripts/
drwxrwxrwx 2 joonaslahtinen joonaslahtinen     4096 tammi  30  2020 media/
drwxrwxrwx 2 joonaslahtinen joonaslahtinen     4096 tammi  30  2020 segmentation_import_example/
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen     4998 tammi  30  2020 sensors.dat*
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen   250864 kesä   17 18:21 sphere_15kS_1mmMr.mat*
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen 39130618 tammi  30  2020 sphere_example.mat*
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/data$ cp sphere_15kS_1mmMr.mat ../../zeffiro_interface-Current/data/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/data$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ cd m
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m$ cd command_line_tools/scripts/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cp joonas_make_all.m ../../../../zeffiro_interface-Current/m
m/     mlapp/ 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cp joonas_make_all.m ../../../../zeffiro_interface-Current/m/co
color_label.m       command_line_tools/ compute_eit_data.m  
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cp joonas_make_all.m ../../../../zeffiro_interface-Current/m/command_line_tools/scripts/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cd ../../../../
sampsa@herique:/media/datadisk/joonas$ cd zeffiro_interface-Current/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ cd m
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m$ cd command_line_tools/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools$ cd scripts/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cat joonas_make_all.m 
run('../../../zeffiro_interface_nodisplay');

zef.file_path = [zef.program_path '/data/'];
zef.file = 'sphere_15kS_1mmMr.mat';

zef_load_nodisplay;

zef.gpu_num = 2;
zef.use_gpu = 1;

zef.source_interpolation_on = 1; 
set(zef.h_source_interpolation_on,'value',1); 
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]); 
[zef.nodes,zef.nodes_b,zef.tetra,zef.sigma_ind,zef.surface_triangles]=fem_mesh([]);
zef.tetra_aux = zef.tetra; 
[zef.sigma,zef.brain_ind,zef.non_source_ind,zef.nodes,zef.tetra,zef.sigma_prisms,zef.prisms,zef.submesh_ind]=zef_sigma([]); 
zef.n_sources_mod = 1; 
zef.source_ind = []; 
set(zef.h_text_elements,'string',num2str(size(zef.tetra,1)+size(zef.prisms,1))); 
set(zef.h_text_nodes,'string',num2str(size(zef.nodes,1)));
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]);
[zef.sensors_attached_volume] = attach_sensors_volume(zef.sensors);
lead_field_matrix;

source_positions = zef.source_positions;
[s_ind_1] = unique(zef.source_interpolation_ind{1});
L = zef.L;
save('SphereSpace.mat','s_ind_1','L','source_positions');

zef.file = 'sphere_15kS_1mmMr.mat';

zef.save_switch = 7;
zef_save_nodisplay;
exit;
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nohup matlab -nodesktop -nodisplay -nosplash < joonas_make_all.m 1>zef_out.txt 2>zef_error.txt &
[1] 41722
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cat zef_error.txt 
Reference to non-existent field 'h_source_interpolation_on'.
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cat script_zef_make_all.m 
run('../zeffiro_interface_nodisplay');

zef.file_path = [zef.program_path '/data/'];
zef.file = 'sphere_example.mat';

zef_load_nodisplay;

zef.gpu_num = 2;
zef.use_gpu = 1;

zef_make_all_nodisplay;

zef.file = 'sphere_example.mat';
zef.save_switch = 7;
zef_save_nodisplay;

exit;
[1]+  Done                    nohup matlab -nodesktop -nodisplay -nosplash < joonas_make_all.m > zef_out.txt 2> zef_error.txt
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cat joonas_make_all.m 
run('../../../zeffiro_interface_nodisplay');

zef.file_path = [zef.program_path '/data/'];
zef.file = 'sphere_15kS_1mmMr.mat';

zef_load_nodisplay;

zef.gpu_num = 2;
zef.use_gpu = 1;

zef.source_interpolation_on = 1; 
set(zef.h_source_interpolation_on,'value',1); 
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]); 
[zef.nodes,zef.nodes_b,zef.tetra,zef.sigma_ind,zef.surface_triangles]=fem_mesh([]);
zef.tetra_aux = zef.tetra; 
[zef.sigma,zef.brain_ind,zef.non_source_ind,zef.nodes,zef.tetra,zef.sigma_prisms,zef.prisms,zef.submesh_ind]=zef_sigma([]); 
zef.n_sources_mod = 1; 
zef.source_ind = []; 
set(zef.h_text_elements,'string',num2str(size(zef.tetra,1)+size(zef.prisms,1))); 
set(zef.h_text_nodes,'string',num2str(size(zef.nodes,1)));
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]);
[zef.sensors_attached_volume] = attach_sensors_volume(zef.sensors);
lead_field_matrix;

source_positions = zef.source_positions;
[s_ind_1] = unique(zef.source_interpolation_ind{1});
L = zef.L;
save('SphereSpace.mat','s_ind_1','L','source_positions');

zef.file = 'sphere_15kS_1mmMr.mat';

zef.save_switch = 7;
zef_save_nodisplay;
exit;
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ pico script_zef_make_all.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nohup matlab -nodesktop -nodisplay -nosplash < script_zef_make_all.m 1>zef_out.txt 2>zef_error.txt &
[1] 43170
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cat zef_error.txt 
Unrecognized function or variable 'fullpath'.

Error in zeffiro_interface_nodisplay (line 17)
zef.program_path = fullpath(cd,'../../');

Error in run (line 91)
evalin('caller', strcat(script, ';'));
 
Reference to non-existent field 'program_path'.
 
Unrecognized function or variable 'zef_load_nodisplay'.
 
Unrecognized function or variable 'zef_make_all_nodisplay'.
 
Unrecognized function or variable 'zef_save_nodisplay'.
 
[1]+  Done                    nohup matlab -nodesktop -nodisplay -nosplash < script_zef_make_all.m > zef_out.txt 2> zef_error.txt
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ cat zeffiro_interface_nodisplay.m 

if not(exist('zef'))
    zef = [];
end

if isfield(zef,'h_zeffiro_window_main')
    if isvalid(zef.h_zeffiro_window_main)
        error('Another instance of Zeffiro interface already open.')
    end
end
clear zef;
zef.ver = ver;
if not(license('test','distrib_computing_toolbox')) || not(any(strcmp(cellstr(char(zef.ver.Name)), 'Parallel Computing Toolbox')))
gpuDeviceCount = 0;
end
zef = rmfield(zef, 'ver');
zef.program_path = cd; 
if not(isdeployed)
zef.code_path = '/m';
addpath(genpath([zef.program_path]));
addpath(genpath([zef.program_path '/m']));
addpath(genpath([zef.program_path '/mlapp']));
addpath([zef.program_path '/fig']);  
addpath([zef.program_path zef.code_path]); 
addpath(genpath([zef.program_path '/plugins']));
end;
zef.h_zeffiro = fopen('zeffiro_interface.ini');
zef.ini_cell = textscan(zef.h_zeffiro,'%s');
zef.save_file_path = zef.ini_cell{1}{2};
zef.save_file = zef.ini_cell{1}{4};
zef.video_codec = zef.ini_cell{1}{6};
zef.use_gpu = str2num(zef.ini_cell{1}{8});
zef.gpu_num = str2num(zef.ini_cell{1}{10});
if gpuDeviceCount > 0 & zef.use_gpu == 1
gpuDevice(zef.gpu_num);
end
zef.parallel_vectors = str2num(zef.ini_cell{1}{12});
zef.snapshot_vertical_resolution = str2num(zef.ini_cell{1}{14});
zef.snapshot_horizontal_resolution = str2num(zef.ini_cell{1}{16});
zef.movie_fps = str2num(zef.ini_cell{1}{18});
zef.font_size = str2num(zef.ini_cell{1}{20});
zef.mlapp = str2num(zef.ini_cell{1}{22});
zef = rmfield(zef,'ini_cell');

zef_data = zef;
zef_init;

zef.clear_axes1 = 0;






sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ client_loop: send disconnect: Broken pipe
wks-95038-mac:~ pursiain$ ssh sampsa@mat-herique.rd.tut.fi
sampsa@mat-herique.rd.tut.fi's password: 
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.8.0-44-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

309 updates can be installed immediately.
165 of these updates are security updates.
To see these additional updates run: apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Thu Jun 17 17:23:20 2021 from 130.230.156.47
sampsa@herique:~$ cd /media/datadisk/client_loop: send disconnect: Broken pipe
wks-95038-mac:~ pursiain$ ssh sampsa@mat-shannon.rd.tut.fi
sampsa@mat-shannon.rd.tut.fi's password: 
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-56-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

428 updates can be installed immediately.
193 of these updates are security updates.
To see these additional updates run: apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Thu Jun 17 17:21:19 2021 from 130.230.156.47
sampsa@shannon:~$ cd /media/datadisk/joonas
-bash: cd: /media/datadisk/joonas: No such file or directory
sampsa@shannon:~$ logout
Connection to mat-shannon.rd.tut.fi closed.
wks-95038-mac:~ pursiain$ ssh sampsa@mat-herique.rd.tut.fi
sampsa@mat-herique.rd.tut.fi's password: 
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.8.0-44-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

309 updates can be installed immediately.
165 of these updates are security updates.
To see these additional updates run: apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Thu Jun 17 19:23:34 2021 from 185.25.79.188
sampsa@herique:~$ cd /media/datadisk/joonas/
sampsa@herique:/media/datadisk/joonas$ cd zeffiro_interface-Current/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ cat zeffiro_interface_nodisplay.m 

if not(exist('zef'))
    zef = [];
end

if isfield(zef,'h_zeffiro_window_main')
    if isvalid(zef.h_zeffiro_window_main)
        error('Another instance of Zeffiro interface already open.')
    end
end
clear zef;
zef.ver = ver;
if not(license('test','distrib_computing_toolbox')) || not(any(strcmp(cellstr(char(zef.ver.Name)), 'Parallel Computing Toolbox')))
gpuDeviceCount = 0;
end
zef = rmfield(zef, 'ver');
zef.program_path = cd; 
if not(isdeployed)
zef.code_path = '/m';
addpath(genpath([zef.program_path]));
addpath(genpath([zef.program_path '/m']));
addpath(genpath([zef.program_path '/mlapp']));
addpath([zef.program_path '/fig']);  
addpath([zef.program_path zef.code_path]); 
addpath(genpath([zef.program_path '/plugins']));
end;
zef.h_zeffiro = fopen('zeffiro_interface.ini');
zef.ini_cell = textscan(zef.h_zeffiro,'%s');
zef.save_file_path = zef.ini_cell{1}{2};
zef.save_file = zef.ini_cell{1}{4};
zef.video_codec = zef.ini_cell{1}{6};
zef.use_gpu = str2num(zef.ini_cell{1}{8});
zef.gpu_num = str2num(zef.ini_cell{1}{10});
if gpuDeviceCount > 0 & zef.use_gpu == 1
gpuDevice(zef.gpu_num);
end
zef.parallel_vectors = str2num(zef.ini_cell{1}{12});
zef.snapshot_vertical_resolution = str2num(zef.ini_cell{1}{14});
zef.snapshot_horizontal_resolution = str2num(zef.ini_cell{1}{16});
zef.movie_fps = str2num(zef.ini_cell{1}{18});
zef.font_size = str2num(zef.ini_cell{1}{20});
zef.mlapp = str2num(zef.ini_cell{1}{22});
zef = rmfield(zef,'ini_cell');

zef_data = zef;
zef_init;

zef.clear_axes1 = 0;






sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ pico zeffiro_interface_nodisplay.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ cd m
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m$ cd command_line_tools/scripts/omm
-bash: cd: command_line_tools/scripts/omm: No such file or directory
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m$ cd command_line_tools/scripts/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nohup matlab -nodesktop -nodisplay -nosplash < script_zef_make_all.m 1>zef_out.txt 2>zef_error.txt &
[1] 48145
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ top

top - 19:33:52 up  3:24,  6 users,  load average: 0,51, 0,11, 0,04
Tasks: 595 total,   1 running, 594 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0,6 us,  0,2 sy,  0,0 ni, 99,2 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 123928,7 free,   1913,9 used,   2702,0 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 125327,3 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
  48878 sampsa    20   0   17004   4628   3520 R   1,0   0,0   0:00.09 top                                                                   
  15799 root      20   0       0      0      0 I   0,3   0,0   0:00.12 kworker/13:0-events                                                   
  45355 root      20   0       0      0      0 I   0,3   0,0   0:00.06 kworker/1:1-events                                                    
  45799 root      20   0       0      0      0 I   0,3   0,0   0:00.05 kworker/u40:0-events_freezable_power_                                 
      1 root      20   0  167996  11824   8304 S   0,0   0,0   0:03.77 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:09.47 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.10 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.62 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.03 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.75 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.72 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.76 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/7                                                           
     54 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/7                                                           
     56 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/7:0H-kblockd                                                  
[1]+  Done                    nohup matlab -nodesktop -nodisplay -nosplash < script_zef_make_all.m > zef_out.txt 2> zef_error.txt
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cat zef_error.txt 
Unrecognized function or variable 'fullpath'.

Error in zeffiro_interface_nodisplay (line 17)
zef.program_path = fullpath(cd,'../../');

Error in run (line 91)
evalin('caller', strcat(script, ';'));
 
Reference to non-existent field 'program_path'.
 
Unrecognized function or variable 'zef_load_nodisplay'.
 
Unrecognized function or variable 'zef_make_all_nodisplay'.
 
Unrecognized function or variable 'zef_save_nodisplay'.
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ pico zeffiro_interface_nodisplay.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ matlab -nodesktop
MATLAB is selecting SOFTWARE OPENGL rendering.

                                                           < M A T L A B (R) >
                                                 Copyright 1984-2020 The MathWorks, Inc.
                                             R2020b Update 1 (9.9.0.1495850) 64-bit (glnxa64)
                                                            September 30, 2020

 
To get started, type doc.
For product information, visit www.mathworks.com.
 
>> cd

/media/datadisk/joonas/zeffiro_interface-Current

>> pwd

ans =

    '/media/datadisk/joonas/zeffiro_interface-Current'

>> a = pwd

a =

    '/media/datadisk/joonas/zeffiro_interface-Current'

>> b = cd

b =

    '/media/datadisk/joonas/zeffiro_interface-Current'

>> fullpath 
Unrecognized function or variable 'fullpath'.
 
>> fullfile
Error using fullfile (line 43)
Not enough input arguments.
 
>> fullfile('')

ans =

  0x0 empty char array

>> matlab.desktop.editor.getActiveFilename
Error using matlab.desktop.editor.getActive (line 20)
The MATLAB Editor is not available without Java.

Error in matlab.desktop.editor.getActiveFilename (line 23)
activeEditor = matlab.desktop.editor.getActive;
 
>> mfilename('fullpath')

ans =

  0x0 empty char array

>> dir

.                              data                           plugins                        zeffiro_plugins.ini            
..                             fig                            zeffiro_interface.ini          
LICENSE                        m                              zeffiro_interface.m            
README.md                      mlapp                          zeffiro_interface_nodisplay.m  

>> help fullfile
 FULLFILE Build full file name from parts.
    F = fullfile(FOLDERNAME1, FOLDERNAME2, ..., FILENAME) builds a full
    file specification F from the folders and file name specified. Input
    arguments FOLDERNAME1, FOLDERNAME2, etc. and FILENAME can be strings,
    character vectors, or cell arrays of character vectors. Non-scalar
    strings and cell arrays of character vectors must all be the same size.
 
    If any input is a string array, F is a string array. Otherwise, if any
    input is a cell array, F is a cell array.  Otherwise, F is a character
    array.
 
    The output of FULLFILE is conceptually equivalent to character vector
    horzcat operation:
 
       F = [FOLDERNAME1 filesep FOLDERNAME2 filesep ... filesep FILENAME]
 
    except that care is taken to handle the cases when the folders begin or
    end with a file separator.
 
    FULLFILE collapses inner repeated file separators unless they appear at 
    the beginning of the full file specification. FULLFILE also collapses 
    relative folders indicated by the dot symbol, unless they appear at 
    the end of the full file specification. Relative folders indicated 
    by the double-dot symbol are not collapsed.
 
    To split a full file name into folder parts, use split(f, filesep).
 
    Examples
      % To build platform dependent paths to files:
         fullfile(matlabroot,'toolbox','matlab','general','Contents.m')
 
      % To build platform dependent paths to a folder:
         fullfile(matlabroot,'toolbox','matlab',filesep)
 
      % To build a collection of platform dependent paths to files:
         fullfile(toolboxdir('matlab'),'iofun',{'filesep.m';'fullfile.m'})
 
    See also FILESEP, PATHSEP, FILEPARTS, GENPATH, PATH, SPLIT.

    Documentation for fullfile
       doc fullfile


>> matlabroot

ans =

    '/usr/local/MATLAB/R2020b'

>> S = dbstack()

S = 

  0x1 empty struct array with fields:

    file
    name
    line

>> S = dbstack().file
Insufficient number of outputs from right hand side of equal sign to satisfy assignment.
 
>> S.file
>> 
[1]+  Stopped                 matlab -nodesktop
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ pico zeffiro_interface_nodisplay.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ cd m
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m$ cd command_line_tools/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools$ cd scripts/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nohup matlab -nodesktop -nodisplay -nosplash < script_zef_make_all.m 1>zef_out.txt 2>zef_error.txt &
[2] 51075
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ top

top - 19:43:13 up  3:34,  6 users,  load average: 1,02, 0,33, 0,13
Tasks: 586 total,   1 running, 584 sleeping,   1 stopped,   0 zombie
%Cpu(s):  0,0 us,  0,0 sy,  0,0 ni,100,0 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 123180,3 free,   2659,9 used,   2704,4 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 124580,9 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
  52136 sampsa    20   0   17004   4644   3540 R   0,3   0,0   0:00.07 top                                                                   
  52268 root      20   0   13264   8108   6992 S   0,3   0,0   0:00.03 sshd                                                                  
      1 root      20   0  167996  11824   8304 S   0,0   0,0   0:03.80 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:09.61 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.10 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.62 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.03 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.75 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.77 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.74 migration/7                                                           
     54 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/7                                                           
     56 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/7:0H-kblockd                                                  
     57 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/8                                                               
     58 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/8                                                         
[2]-  Done                    nohup matlab -nodesktop -nodisplay -nosplash < script_zef_make_all.m > zef_out.txt 2> zef_error.txt
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cat zef_error.txt 
Unrecognized function or variable 'fullpath'.

Error in zeffiro_interface_nodisplay (line 17)
zef.program_path = fullpath(cd,'../../');

Error in run (line 91)
evalin('caller', strcat(script, ';'));
 
Reference to non-existent field 'program_path'.
 
Unrecognized function or variable 'zef_load_nodisplay'.
 
Unrecognized function or variable 'zef_make_all_nodisplay'.
 
Unrecognized function or variable 'zef_save_nodisplay'.
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ fg
matlab -nodesktop	(wd: /media/datadisk/joonas/zeffiro_interface-Current)

>> 
[1]+  Stopped                 matlab -nodesktop  (wd: /media/datadisk/joonas/zeffiro_interface-Current)
(wd now: /media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts)
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools$ ls
scripts  zef_load_nodisplay.m  zef_make_all_nodisplay.m  zef_save_nodisplay.m  zeffiro_interface_nodisplay.m
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools$ rm zeffiro_interface_nodisplay.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ pico zeffiro_interface_nodisplay.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ cd m/command_line_tools/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools$ nohup matlab -nodesktop -nodisplay -nosplash < script_zef_make_all.m 1>zef_out.txt 2>zef_error.txt &
[2] 53037
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools$ -bash: script_zef_make_all.m: No such file or directory
top

top - 19:47:20 up  3:38,  7 users,  load average: 0,01, 0,14, 0,09
Tasks: 590 total,   1 running, 588 sleeping,   1 stopped,   0 zombie
%Cpu(s):  0,1 us,  0,0 sy,  0,0 ni, 99,9 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 123168,1 free,   2670,8 used,   2705,7 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 124569,7 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
   4365 joonasl+  20   0  202216 104500  46540 S   1,7   0,1   0:54.15 Xtightvnc                                                             
  53042 sampsa    20   0   17004   4488   3380 R   0,7   0,0   0:00.11 top                                                                   
  19070 root      20   0       0      0      0 I   0,3   0,0   0:00.29 kworker/0:2-events                                                    
  50727 root      20   0       0      0      0 I   0,3   0,0   0:00.05 kworker/u40:2-flush-259:0                                             
      1 root      20   0  167996  11824   8304 S   0,0   0,0   0:03.87 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:09.66 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.11 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.62 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.03 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.75 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.77 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.74 migration/7                                                           
     54 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/7                                                           
     56 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/7:0H-kblockd                                                  
[2]-  Exit 1                  nohup matlab -nodesktop -nodisplay -nosplash < script_zef_make_all.m > zef_out.txt 2> zef_error.txt
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools$ cat zef_error.txt
cat: zef_error.txt: No such file or directory
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools$ cd scripts/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nohup matlab -nodesktop -nodisplay -nosplash < script_zef_make_all.m 1>zef_out.txt 2>zef_error.txt &
[2] 53112
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ top

top - 19:48:21 up  3:39,  7 users,  load average: 0,31, 0,19, 0,11
Tasks: 604 total,   1 running, 602 sleeping,   1 stopped,   0 zombie
%Cpu(s):  0,1 us,  0,1 sy,  0,0 ni, 99,8 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 123131,8 free,   2703,7 used,   2709,1 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 124533,7 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
   4365 joonasl+  20   0  235496 107428  49468 S   1,0   0,1   0:55.66 Xtightvnc                                                             
  53048 joonasl+  20   0 1105808  76936  50732 S   1,0   0,1   0:02.97 nautilus                                                              
  53025 joonasl+  20   0   14120   5948   4460 S   0,7   0,0   0:00.40 sshd                                                                  
  53862 sampsa    20   0   17004   4616   3508 R   0,7   0,0   0:00.16 top                                                                   
  54932 root      20   0   13264   7884   6768 S   0,7   0,0   0:00.04 sshd                                                                  
      1 root      20   0  167996  11824   8304 S   0,0   0,0   0:03.88 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:09.68 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.11 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.62 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.03 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.75 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.74 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.77 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.74 migration/7                                                           
     54 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/7                                                           
[2]-  Done                    nohup matlab -nodesktop -nodisplay -nosplash < script_zef_make_all.m > zef_out.txt 2> zef_error.txt
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cat zef_error.txt 
Error using run (line 66)
../zeffiro_interface_nodisplay not found.
 
Unable to resolve the name zef.program_path.
 
Unrecognized function or variable 'zef_load_nodisplay'.
 
Unrecognized function or variable 'zef_make_all_nodisplay'.
 
Unrecognized function or variable 'zef_save_nodisplay'.
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ pico script_zef_make_all.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nohup matlab -nodesktop -nodisplay -nosplash < script_zef_make_all.m 1>zef_out.txt 2>zef_error.txt &
[2] 56363
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ top

top - 19:50:22 up  3:41,  7 users,  load average: 0,56, 0,34, 0,17
Tasks: 605 total,   1 running, 603 sleeping,   1 stopped,   0 zombie
%Cpu(s):  0,3 us,  0,2 sy,  0,0 ni, 99,4 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 121846,2 free,   3976,8 used,   2721,6 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 123249,7 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
  54945 joonasl+  20   0   14,1g   1,5g 414400 S   8,6   1,2   0:57.66 MATLAB                                                                
  56098 joonasl+  20   0 2407956 206228  60280 S   3,0   0,2   0:06.75 cef_helper                                                            
   4365 joonasl+  20   0  240912 116624  58664 S   1,3   0,1   0:57.77 Xtightvnc                                                             
  53025 joonasl+  20   0   14120   5948   4460 S   1,0   0,0   0:00.95 sshd                                                                  
  57782 sampsa    20   0   17004   4700   3596 R   0,7   0,0   0:00.05 top                                                                   
   1128 root      20   0  402856  23328  10244 S   0,3   0,0   0:08.84 f2b/server                                                            
      1 root      20   0  167996  11824   8304 S   0,0   0,0   0:03.89 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:09.83 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.11 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.63 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.03 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.75 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.74 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.77 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.74 migration/7                                                           
[2]-  Done                    nohup matlab -nodesktop -nodisplay -nosplash < script_zef_make_all.m > zef_out.txt 2> zef_error.txt
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cat zef_error.txt 
Array indices must be positive integers or logical values.

Error in fem_mesh (line 41)
x_lim = [min(reuna_p{end}(:,1)) max(reuna_p{end}(:,1))];

Error in zef_make_all_nodisplay (line 3)
[zef.nodes,zef.nodes_b,zef.tetra,zef.sigma_ind,zef.surface_triangles]=fem_mesh([]);
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cd ../../data
-bash: cd: ../../data: No such file or directory
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cd ../../../data
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/data$ matlab -nodesktop
MATLAB is selecting SOFTWARE OPENGL rendering.

                                                           < M A T L A B (R) >
                                                 Copyright 1984-2020 The MathWorks, Inc.
                                             R2020b Update 1 (9.9.0.1495850) 64-bit (glnxa64)
                                                            September 30, 2020

 
To get started, type doc.
For product information, visit www.mathworks.com.
 
>> load sphere_15kS_1mmMr.mat
>> sc_points
Unrecognized function or variable 'sc_points'.
 
>> zef_data.sc_points

ans =

     []

>> zef_data.sk_points

ans =

     []

>> zef_data.sk_nodes 
Reference to non-existent field 'sk_nodes'.
 
>> zef_data.d1_points                 

ans =

     []

>> zef_data.d22_points

ans =

     []

>>       
[2]+  Stopped                 matlab -nodesktop
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/data$ cd ../m/command_line_tools/scripts/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ pico script_zef_make_all.m 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ nohup matlab -nodesktop -nodisplay -nosplash < script_zef_make_all.m 1>zef_out.txt 2>zef_error.txt &
[3] 59999
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ top

top - 19:55:50 up  3:46,  7 users,  load average: 0,02, 0,18, 0,15
Tasks: 603 total,   1 running, 600 sleeping,   2 stopped,   0 zombie
%Cpu(s):  9,3 us,  2,0 sy,  0,0 ni, 88,7 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
MiB Mem : 128544,6 total, 120215,5 free,   5594,7 used,   2734,3 buff/cache
MiB Swap:   2048,0 total,   2048,0 free,      0,0 used. 121619,6 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                               
  59999 sampsa    20   0 6097680 339176 184844 S 243,8   0,3   0:02.83 MATLAB                                                                
  60730 sampsa    20   0   17004   4648   3544 R  12,5   0,0   0:00.03 top                                                                   
      1 root      20   0  167996  11824   8304 S   0,0   0,0   0:03.91 systemd                                                               
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.01 kthreadd                                                              
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp                                                                
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par_gp                                                            
      6 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/0:0H-kblockd                                                  
      9 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 mm_percpu_wq                                                          
     10 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/0                                                           
     11 root      20   0       0      0      0 I   0,0   0,0   0:10.26 rcu_sched                                                             
     12 root      rt   0       0      0      0 S   0,0   0,0   0:00.11 migration/0                                                           
     13 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/0                                                         
     14 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/0                                                               
     15 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/1                                                               
     16 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/1                                                         
     17 root      rt   0       0      0      0 S   0,0   0,0   0:00.63 migration/1                                                           
     18 root      20   0       0      0      0 S   0,0   0,0   0:00.03 ksoftirqd/1                                                           
     20 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/1:0H-kblockd                                                  
     21 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/2                                                               
     22 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/2                                                         
     23 root      rt   0       0      0      0 S   0,0   0,0   0:00.76 migration/2                                                           
     24 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/2                                                           
     26 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/2:0H-kblockd                                                  
     27 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/3                                                               
     28 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/3                                                         
     29 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/3                                                           
     30 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/3                                                           
     32 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/3:0H-kblockd                                                  
     33 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/4                                                               
     34 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/4                                                         
     35 root      rt   0       0      0      0 S   0,0   0,0   0:00.74 migration/4                                                           
     36 root      20   0       0      0      0 S   0,0   0,0   0:00.01 ksoftirqd/4                                                           
     38 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/4:0H-kblockd                                                  
     39 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/5                                                               
     40 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/5                                                         
     41 root      rt   0       0      0      0 S   0,0   0,0   0:00.78 migration/5                                                           
     42 root      20   0       0      0      0 S   0,0   0,0   0:00.00 ksoftirqd/5                                                           
     44 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/5:0H-kblockd                                                  
     45 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/6                                                               
     46 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/6                                                         
     47 root      rt   0       0      0      0 S   0,0   0,0   0:00.73 migration/6                                                           
     48 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/6                                                           
     50 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/6:0H-kblockd                                                  
     51 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/7                                                               
     52 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/7                                                         
     53 root      rt   0       0      0      0 S   0,0   0,0   0:00.74 migration/7                                                           
     54 root      20   0       0      0      0 S   0,0   0,0   0:00.02 ksoftirqd/7                                                           
     56 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 kworker/7:0H-kblockd                                                  
     57 root      20   0       0      0      0 S   0,0   0,0   0:00.00 cpuhp/8                                                               
     58 root     -51   0       0      0      0 S   0,0   0,0   0:00.00 idle_inject/8                                                         
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m$ cd ..
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ cd ..
sampsa@herique:/media/datadisk/joonas$ cd zeffiro_interface-master/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master$ cd m
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m$ cd command_line_tools/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools$ ll
total 28
drwxrwxrwx 3 joonaslahtinen joonaslahtinen 4096 kesä   17 18:18 ./
drwxrwxrwx 4 joonaslahtinen joonaslahtinen 4096 kesä   17 18:08 ../
drwxrwxrwx 2 joonaslahtinen joonaslahtinen 4096 kesä   17 18:19 scripts/
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen  936 kesä   17 15:41 zef_load_nodisplay.m*
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen  527 kesä   17 15:41 zef_make_all_nodisplay.m*
-rwxrwxrwx 1 joonaslahtinen joonaslahtinen 5095 kesä   17 15:41 zef_save_nodisplay.m*
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools$ cd scripts/
[3]   Done                    nohup matlab -nodesktop -nodisplay -nosplash < script_zef_make_all.m > zef_out.txt 2> zef_error.txt  (wd: /media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts)
(wd now: /media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts)
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-master/m/command_line_tools/scripts$ cd /media/datadisk/joonas/
sampsa@herique:/media/datadisk/joonas$ cd zeffiro_interface-Current/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current$ cd m/command_line_tools/scripts/
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cat  script_zef_make_all.m 

run('../../../zeffiro_interface_nodisplay');

zef.file_path = [zef.program_path '/data/'];
zef.file = 'sphere_example.mat';

zef_load_nodisplay;

zef.gpu_num = 2;
zef.use_gpu = 1;

zef_make_all_nodisplay;

zef.file = 'sphere_example.mat';
zef.save_switch = 7;
zef_save_nodisplay;

exit;
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cat zef_error.txt 
Unrecognized function or variable 'h'.

Error in source_interpolation (line 75)
waitbar(1,h,['Interpolation 1. Ready: ' datestr(datevec(now+(size_center_points/i - 1)*time_val/86400)) '.']);

Error in lead_field_matrix (line 133)
[zef.source_interpolation_ind] = source_interpolation([]);

Error in zef_make_all_nodisplay (line 10)
lead_field_matrix;
 
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ cat ../../source_interpolation.m 
%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [source_interpolation_ind] = source_interpolation(void)

brain_ind = evalin('base','zef.brain_ind');
source_positions = evalin('base','zef.source_positions');
nodes = evalin('base','zef.nodes');
tetra = evalin('base','zef.tetra');

if evalin('base','zef.location_unit_current') == 2 
source_positions = 10*source_positions;
end

if evalin('base','zef.location_unit_current') == 3
zef.source_positions = 1000*source_positions;
end

rand_perm_aux = [];
if evalin('base','zef.n_sources') < size(source_positions,1)
rand_perm_aux = randperm(size(source_positions,1));
rand_perm_aux = rand_perm_aux(1:evalin('base','zef.n_sources'));
source_positions = source_positions(rand_perm_aux,:);
end

[center_points I center_points_ind] = unique(tetra(brain_ind,:));
source_interpolation_ind{1} = zeros(length(center_points),1);
source_interpolation_aux = source_interpolation_ind{1};
center_points = nodes(center_points,:)';

source_positions = source_positions';
ones_vec = ones(size(source_positions,2),1);

size_center_points = size(center_points,2); 

use_gpu  = evalin('base','zef.use_gpu');
gpu_num  = evalin('base','zef.gpu_num');

if use_gpu == 1 & gpuDeviceCount > 0
center_points = gpuArray(center_points);
source_positions = gpuArray(source_positions);
source_interpolation_aux = gpuArray(source_interpolation_aux);
end 

par_num = evalin('base','zef.parallel_vectors');
bar_ind = ceil(size_center_points/(50*par_num));
i_ind = 0;

tic; 
for i = 1 : par_num : size_center_points

i_ind = i_ind + 1;
block_ind = [i: min(i+par_num-1,size_center_points)];
aux_vec = center_points(:,block_ind);
aux_vec = reshape(aux_vec,3,1,length(block_ind));
norm_vec = sum((source_positions(:,:,ones(1,length(block_ind))) - aux_vec(:,ones_vec,:)).^2);
[min_val min_ind] = min(norm_vec,[],2);
source_interpolation_aux(block_ind) = min_ind(:);

time_val = toc;
if i == 1
h = waitbar(i/size_center_points,['Interpolation 1.']);    
elseif mod(i_ind,bar_ind)==0 
waitbar(i/size_center_points,h,['Interpolation 1. Ready: ' datestr(datevec(now+(size_center_points/i - 1)*time_val/86400)) '.']);
end

end

source_interpolation_ind{1} = (gather(source_interpolation_aux));

if not(isempty(rand_perm_aux))
source_interpolation_ind{1} = rand_perm_aux(source_interpolation_ind{1});
end
source_interpolation_ind{1} = reshape(source_interpolation_ind{1}(center_points_ind), length(brain_ind), 4); 

waitbar(1,h,['Interpolation 1. Ready: ' datestr(datevec(now+(size_center_points/i - 1)*time_val/86400)) '.']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
visible_vec = [];
color_cell = cell(0);
aux_brain_ind = [];
aux_dir_mode = [];
compartment_tags = evalin('base','zef.compartment_tags');
for k = 1 : length(compartment_tags)

        var_0 = ['zef.' compartment_tags{k} '_on'];
        var_1 = ['zef.' compartment_tags{k} '_sigma'];
        var_2 = ['zef.' compartment_tags{k} '_priority'];
        var_3 = ['zef.' compartment_tags{k} '_visible'];
    color_str = evalin('base',['zef.' compartment_tags{k} '_color']);
   
on_val = evalin('base',var_0);      
sigma_val = evalin('base',var_1);  
priority_val = evalin('base',var_2);
visible_val = evalin('base',var_3);
if on_val
i = i + 1;
sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
color_cell{i} = color_str;
visible_vec(i,1) = i*visible_val;
if evalin('base',['zef.' compartment_tags{k} '_sources']);
    aux_brain_ind = [aux_brain_ind i];
end

end
end

source_positions_aux = source_positions;

for ab_ind = 1 : length(aux_brain_ind)

aux_point_ind = unique(gather(source_interpolation_ind{1}));
source_positions = source_positions_aux(:,aux_point_ind);
ones_vec = ones(size(source_positions,2),1);

s_ind_1{ab_ind} = aux_point_ind;

center_points = evalin('base',['zef.reuna_p{' int2str(aux_brain_ind(ab_ind)) '}']);
center_points = center_points';

source_interpolation_ind{2}{ab_ind} = zeros(length(center_points),1);
source_interpolation_aux = source_interpolation_ind{2}{ab_ind};

size_center_points = size(center_points,2); 

use_gpu  = evalin('base','zef.use_gpu');
gpu_num  = evalin('base','zef.gpu_num');

if use_gpu == 1 & gpuDeviceCount > 0
center_points = gpuArray(center_points);
source_positions = gpuArray(source_positions);
source_interpolation_aux = gpuArray(source_interpolation_aux);
end 

par_num = evalin('base','zef.parallel_vectors');
bar_ind = ceil(size_center_points/(50*par_num));
i_ind = 0;

tic;

for i = 1 : par_num : size_center_points

i_ind = i_ind + 1;
block_ind = [i: min(i+par_num-1,size_center_points)];
aux_vec = center_points(:,block_ind);
aux_vec = reshape(aux_vec,3,1,length(block_ind));
norm_vec = sum((source_positions(:,:,ones(1,length(block_ind))) - aux_vec(:,ones_vec,:)).^2);
[min_val min_ind] = min(norm_vec,[],2);
source_interpolation_aux(block_ind) = min_ind(:);

time_val = toc;
if mod(i_ind,bar_ind)==0 
waitbar(i/size_center_points,h,['Interp. 2: ' num2str(ab_ind) '/' num2str(length(aux_brain_ind)) '. Ready: ' datestr(datevec(now+(size_center_points/i - 1)*time_val/86400)) '.']);
end

end

source_interpolation_ind{2}{ab_ind} = (s_ind_1{ab_ind}(gather(source_interpolation_aux)));

if not(isempty(rand_perm_aux))
source_interpolation_ind{2}{ab_ind} = rand_perm_aux(source_interpolation_ind{2});
end
triangles = evalin('base',['zef.reuna_t{' int2str(aux_brain_ind(ab_ind)) '}']);
source_interpolation_ind{2}{ab_ind} = source_interpolation_ind{2}{ab_ind}(triangles); 


waitbar(1,h,['Interp. 2: ' num2str(ab_ind) '/' num2str(length(aux_brain_ind)) '. Ready: ' datestr(datevec(now+(size_center_points/i - 1)*time_val/86400)) '.']);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source_direction_mode = evalin('base','zef.source_direction_mode');

%if source_direction_mode == 2
    
source_interpolation_ind{3} = zeros(length(source_positions),1);
source_interpolation_aux = source_interpolation_ind{3};

aux_p = [];
aux_t = [];

for ab_ind = 1 : length(aux_brain_ind)

aux_t = [aux_t ; size(aux_p,1) + evalin('base',['zef.reuna_t{' int2str(aux_brain_ind(ab_ind)) '}'])];
aux_p = [aux_p ; evalin('base',['zef.reuna_p{' int2str(aux_brain_ind(ab_ind)) '}'])];

end

center_points = (1/3)*(aux_p(aux_t(:,1),:) + aux_p(aux_t(:,2),:) + aux_p(aux_t(:,3),:));
center_points = center_points';


size_center_points = size(center_points,2); 
size_source_positions = size(source_positions,2); 
ones_vec = ones(size(center_points,2),1);

use_gpu  = evalin('base','zef.use_gpu');
gpu_num  = evalin('base','zef.gpu_num');

if use_gpu == 1 & gpuDeviceCount > 0
center_points = gpuArray(center_points);
source_positions = gpuArray(source_positions);
source_interpolation_aux = gpuArray(source_interpolation_aux);
end 

par_num = evalin('base','zef.parallel_vectors');
bar_ind = ceil(size_center_points/(50*par_num));
i_ind = 0;

tic;

for i = 1 : par_num : size_source_positions

i_ind = i_ind + 1;
block_ind = [i: min(i+par_num-1,size_source_positions)];
aux_vec = source_positions(:,block_ind);
aux_vec = reshape(aux_vec,3,1,length(block_ind));
norm_vec = sum((center_points(:,:,ones(1,length(block_ind))) - aux_vec(:,ones_vec,:)).^2);
[min_val min_ind] = min(norm_vec,[],2);
source_interpolation_aux(block_ind) = min_ind(:);

time_val = toc;
if mod(i_ind,bar_ind)==0 
waitbar(i/size_source_positions,h,['Interp. 3: Ready: ' datestr(datevec(now+(size_source_positions/i - 1)*time_val/86400)) '.']);
end
end

source_interpolation_ind{3} = (gather(source_interpolation_aux));

% if not(isempty(rand_perm_aux))
% source_interpolation_ind{2} = rand_perm_aux(source_interpolation_ind{2});
% end
% triangles = evalin('base',['zef.reuna_t{' int2str(aux_brain_ind) '}']);
% source_interpolation_ind{2} = source_interpolation_ind{2}(triangles); 

waitbar(1,h,['Interp. 3: Ready: ' datestr(datevec(now+(size_source_positions/i - 1)*time_val/86400)) '.']);

close(h)

end
sampsa@herique:/media/datadisk/joonas/zeffiro_interface-Current/m/command_line_tools/scripts$ pico ../../source_interpolation.m 

  GNU nano 4.8                               ../../source_interpolation.m                                          
center_points = center_points';


size_center_points = size(center_points,2); 
size_source_positions = size(source_positions,2); 
ones_vec = ones(size(center_points,2),1);

use_gpu  = evalin('base','zef.use_gpu');
gpu_num  = evalin('base','zef.gpu_num');

if use_gpu == 1 & gpuDeviceCount > 0
center_points = gpuArray(center_points);
source_positions = gpuArray(source_positions);
source_interpolation_aux = gpuArray(source_interpolation_aux);
end 

par_num = evalin('base','zef.parallel_vectors');
bar_ind = ceil(size_center_points/(50*par_num));
i_ind = 0;

tic;

for i = 1 : par_num : size_source_positions

i_ind = i_ind + 1;
block_ind = [i: min(i+par_num-1,size_source_positions)];
aux_vec = source_positions(:,block_ind);
aux_vec = reshape(aux_vec,3,1,length(block_ind));
norm_vec = sum((center_points(:,:,ones(1,length(block_ind))) - aux_vec(:,ones_vec,:)).^2);
[min_val min_ind] = min(norm_vec,[],2);
source_interpolation_aux(block_ind) = min_ind(:);

time_val = toc;
if mod(i_ind,bar_ind)==0 
waitbar(i/size_source_positions,h,['Interp. 3: Ready: ' datestr(datevec(now+(size_source_positions/i - 1)*time_val>
end
end

source_interpolation_ind{3} = (gather(source_interpolation_aux));

% if not(isempty(rand_perm_aux))
% source_interpolation_ind{2} = rand_perm_aux(source_interpolation_ind{2});
% end
% triangles = evalin('base',['zef.reuna_t{' int2str(aux_brain_ind) '}']);
% source_interpolation_ind{2} = source_interpolation_ind{2}(triangles); 

waitbar(1,h,['Interp. 3: Ready: ' datestr(datevec(now)) '.']);

close(h)

end
