cat success-SDmin.sh 
    1  free
    2  git clone https://github.com/basujindal/stable-diffusion.git
    3  mkdir miniconda
    4  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  -O miniconda/inst.sh
    5  bash miniconda/inst.sh -b -u -p miniconda/
    6  exec /bin/bash
    7  wget http://192.168.1.147:9000/v1-5-pruned-emaonly.ckpt
    8  pwd
    9  cd stable-diffusion/
   10  ls models/ldm/stable-diffusion-v1/
   11  mkdir -p models/ldm/stable-diffusion-v1/
   12  mv ../v1-5-pruned-emaonly.ckpt models/ldm/stable-diffusion-v1/
   13  ln -s /home/vagrant/stable-diffusion/models/ldm/stable-diffusion-v1/v1-5-pruned-emaonly.ckpt models/ldm/stable-diffusion-v1/model.ckpt
   14  ls -la models/ldm/stable-diffusion-v1/
   15  ls
   16  python optimizedSD/optimized_txt2img.py --prompt "Cyberpunk style image of a Tesla car reflection in rain" --H 512 --W 512 --seed 27 --n_iter 2 --n_samples 5 --ddim_steps 50
   17  python3 optimizedSD/optimized_txt2img.py --prompt "Cyberpunk style image of a Tesla car reflection in rain" --H 512 --W 512 --seed 27 --n_iter 2 --n_samples 5 --ddim_steps 50
   18  cd ..
   19  miniconda/bin/conda init bash
   20  exec /bin/bash
   21  htop
   22  sensors
   23  apt install lm-sensors -y
   24  sensors
   25  sudo sensors
   26  sensors-detect
   27  cd stable-diffusion/
   28  conda env create -f environment.yaml
   29  ls -la models/ldm/stable-diffusion-v1/
   30  ls -la models/ldm/stable-diffusion-v1/ -h
   31  wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt
   32  cp v1-5-pruned-emaonly.ckpt models/ldm/stable-diffusion-v1/
   33  ls models/ldm/stable-diffusion-v1/
   34  ls -la models/ldm/stable-diffusion-v1/
   35  ls -la models/ldm/stable-diffusion-v1/ -h
   36  ls -la
   37  ls -la -h
   38  rm -f  models/ldm/stable-diffusion-v1/v1-5-pruned-emaonly.ckpt 
   39  ls -la models/ldm/stable-diffusion-v1/ -h
   40  mv v1-5-pruned-emaonly.ckpt models/ldm/stable-diffusion-v1/
   41  ls -la models/ldm/stable-diffusion-v1/ -h
   42  history
   43  conda activate ldm
   44  python optimizedSD/optimized_txt2img.py --prompt "Cyberpunk style image of a Tesla car reflection in rain" --H 512 --W 512 --seed 27 --n_iter 2 --n_samples 5 --ddim_steps 50
   45  python optimizedSD/optimized_txt2img.py --prompt "Spongebob fucks patrick" --H 512 --W 512 --seed 27 --n_iter 2 --n_samples 5 --ddim_steps 50
   46  clear
   47  cd ..
   48  ls
   49  mkdir ldm2
   50  cd stable-diffusion/
   51  cd ..
   52  cd ldm2/
   53  git clone https://github.com/CompVis/stable-diffusion.git
   54  cd stable-diffusion/
   55  clear
   56  ls
   57  cd ldm2/
   58  ls
   59  cd stable-diffusion/
   60  ls
   61  vi environment.yaml 
   62  conda env create -f environment.yaml 
   63  conda activate ldm2
   64  clear
   65  ln -s /home/vagrant/stable-diffusion/models/ldm/stable-diffusion-v1/v1-5-pruned-emaonly.ckpt models/ldm/stable-diffusion-v1/model.ckpt
   66  mkdir -p models/ldm/stable-diffusion-v1/
   67  ln -s /home/vagrant/stable-diffusion/models/ldm/stable-diffusion-v1/v1-5-pruned-emaonly.ckpt models/ldm/stable-diffusion-v1/model.ckpt
   68  ls -la models/ldm/stable-diffusion-v1/
   69  python scripts/txt2img.py --prompt "a photograph of an astronaut riding a horse" --plms 
   70  clear
   71  history >> success-SDmin.sh
