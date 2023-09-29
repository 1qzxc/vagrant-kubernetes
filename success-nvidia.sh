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

------



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
   18  nvidia-smi
   19  cat success.sh 
   20  dpkg -l | grep -i cuda
   21  nvcc --version
   22  apt install nvidia-cuda-toolkit -y
   23  nvcc -V
   24  pip3 install torch==1.5.1+cu101 torchvision==0.6.1+cu101 -f https://download.pytorch.org/whl/torch_stable.html
   25  apt install python3-pip -н
   26  apt install python3-pip -y
   27  conda
   28  touch test.py
   29  vi test.py 
   30  python3 test.py 
   31  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
   32  mkdir miniconda3
   33  mv Miniconda3-latest-Linux-x86_64.sh miniconda3/
   34  bash miniconda3/Miniconda3-latest-Linux-x86_64.sh -b -u -p miniconda3/
   35  conda
   36  exec /bin/bash
   37  conda
   38  miniconda3/bin/conda init bash
   39  conda
   40  exec /bin/bash
   41  conda install pytorch torchvision cudatoolkit=10.1 -c pytorch
   42  ls
   43  python3 test.py 
   44  vi test.py 
	   45  python3 test.py 
	   46  touch test2.py
   47  vi test2.py 
   48  python3 test2.py 
   49  vi test.py 
   50  python3 test.py 
   51  pip3 install torch==1.10.1+cu113 torchvision==0.11.2+cu113 torchaudio===0.10.1+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html
   52  nvcc -V
   53  pip3 install torch==1.10.1+cu113 torchvision==0.11.2+cu113 torchaudio===0.10.1+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html
   54  pip3 install torch torchvision torchaudio -f https://download.pytorch.org/whl/cu113/torch_stable.html
   55  python3 test.py 
   56  clear
   57  ls
   58  history >> success-3.txt

------


root@node-2:/home/vagrant# cat success-torch.py 
    1  lspci -nnk
    2  apt install nvidia-utils-535-server -y
    3  apt install nvidia-headless-535-server -y
    4  apt install libnvidia-encode-535-server  -y
    5  apt install nvidia-cuda-toolkit -y
    6  nvcc -V
    7  apt install python3-pip -y
    8  pip3 install torch torchvision torchaudio
    9  clear
   10  ls
   11  touch test.py
   12  vi test.py 
   13  python3 test.py 
   14  nvcc -V
   15  nvidia-smi
   16  dmesg
   17  reboot
   18  vi test.py 
   19  dmesg
   20  lspci -nnk
   21  clear
   22  nvidia-smi
   23  python3 test.py 
   24  history >> success-torch.py
