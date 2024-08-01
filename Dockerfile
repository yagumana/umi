# 使用するベースイメージ
FROM python:3.9

RUN apt-get update && apt-get install -y wget
RUN apt-get update && apt-get install -y tmux

# 必要なシステムパッケージのインストール
RUN apt-get update && apt-get install -y \
    docker.io \
    cmake \
    libosmesa6-dev \
    libgl1-mesa-glx \
    libglfw3 \
    patchelf \
    exiftool
    
# pip のバージョンを更新
RUN pip install --upgrade pip

COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt

# 特殊なインストールが必要なパッケージ
RUN pip install git+https://github.com/cheng-chi/spnav.git@c1c938ebe3cc542db4685e0d13850ff1abfdb943
RUN pip install git+https://github.com/cheng-chi/robosuite.git@3f2c3116f1c0a1916e94bfa28da4d055927d1ab3


# dockerが起動し続けるためのもの
CMD ["tail", "-f", "/dev/null"]

# ENTRYPOINT ["/bin/bash"]