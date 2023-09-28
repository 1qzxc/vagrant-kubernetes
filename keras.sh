sudo mkdir --parents --mode=0755 /etc/apt/keyrings
    2  wget https://repo.radeon.com/rocm/rocm.gpg.key -O - |     gpg --dearmor | sudo tee /etc/apt/keyrings/rocm.gpg > /dev/null
    3  sudo tee /etc/apt/sources.list.d/amdgpu.list <<'EOF'
    4  deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/amdgpu/latest/ubuntu jammy main
    5  EOF
    6  sudo tee /etc/apt/sources.list.d/rocm.list <<'EOF'
    7  deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/debian jammy main
    8  echo -e 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' | sudo tee /etc/apt/preferences.d/rocm-pin-600
    9  EOF
   10  echo -e 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' | sudo tee /etc/apt/preferences.d/rocm-pin-600
   11  vi /etc/apt/sources.list.d/rocm.list
   12  apt update
   13  apt install amdgpu-dkms -н
   14  apt install amdgpu-dkms -y
   15  apt install rocm-hip-libraries -н
   16  apt install rocm-hip-libraries -y
   17  reboot
   18  history
   19  apt install python3-dev python3-pip 
   20  apt install python3-venv -y
   21  tensorflow-app && cd tensorflow-app 
   22  mkdir tensorflow-app && cd tensorflow-app 
   23  python3 -m venv venv
   24  source venv/bin/activate 
   25  pip install --upgrade tensorflow 
   26  pip install --upgrade tensorflow-addons
   27  apt install rocm-libs rccl -y
   28  python3 -c 'import tensorflow' 2> /dev/null && echo 'Success' || echo 'Failure'
   29  git clone https://github.com/tensorflow/models.git
   30  touch test.py
   31  vi test.py 
   32  python3 test.py 
   33  pip install keras
   34  vi amdtest.py
   35  python3 amdtest.py 
   36  pip install tensorflow-rocm -н
   37  pip install tensorflow-rocm -y
   38  pip install tensorflow-rocm
   39  history
