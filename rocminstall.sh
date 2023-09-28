    1  sudo mkdir --parents --mode=0755 /etc/apt/keyrings
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
