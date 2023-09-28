    1  uptime
    2  history
    3  add-apt-repository universe && sudo apt update -y
    4  pip3
    5   apt install python3-pip -y
    6  apt install clinfo -y
    7  clinfo
    8  amdgpu-install --usecase=opencl,graphics -y
    9  wget https://repo.radeon.com/amdgpu-install/23.10.3/ubuntu/jammy/amdgpu-install_5.5.50503-1_all.deb
   10  ls
   11  dpkg -i amdgpu-install_5.5.50503-1_all.deb
   12  amdgpu-install --usecase=opencl,graphics -y
   13  vi /etc/apt/sources.list.d/rocm.list
   14  vi /etc/apt/sources.list.d/amdgpu.list
   15  amdgpu-install -y --accept-eula --usecase=opencl --opencl=rocr,legacy
   16  sudo usermod -a -G render $LOGNAME && sudo usermod -a -G video $LOGNAME
   17  clinfo
   18  history >> success.sh
