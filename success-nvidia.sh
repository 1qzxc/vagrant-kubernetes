root@node-2:/home/vagrant# cat success.sh 
    1  dmesg
    2  dmesg | grep nvidia
    3  nvidia-smi
    4  lspci | egrep -I 'vga|display|3d'
    5  lspci
    6  lspci --nnk
    7  lspci -nnk
    8  nvidia-smi
    9  apt install nvidia-utils-535-server -y
   10  apt install nvidia-headless-535-server -y
   11  apt install libnvidia-encode-535-server  -y
   12  apt install nvidia-headless-535-server -y
   13  lspci -nnk
   14  reboot
   15  lspci -nnk
   16  history
   17  history >> success.sh
