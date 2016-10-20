
# docker-sshd
defines a docker container running Arch Linux with the Lidar library installed,
including but not limited to: opencv with extra modules and CUDA, ROS stacks etc.


## Build Arch Linux docker image

    MYUSER=${USER}
    MYARCH=$(uname -m)
    sudo docker build -t ${MYUSER}/archlidar-${MYARCH}:latest \
        -v $HOME/Downloads/sources/pacman-cache-x64:/var/cache/pacman/pkg/:rw \
        .

## Run and test

    # run as daemon, or replace '-d' with '--rm' to test the image
    sudo nvidia-docker run \
        -d \
        -i -t \
        --privileged \
        -v /etc/ssh/ssh_host_key:/etc/ssh/ssh_host_key:ro \
        -v /etc/ssh/ssh_host_rsa_key:/etc/ssh/ssh_host_rsa_key:ro \
        -v /etc/ssh/ssh_host_dsa_key:/etc/ssh/ssh_host_dsa_key:ro \
        -v /etc/ssh/ssh_host_ecdsa_key:/etc/ssh/ssh_host_ecdsa_key:ro \
        -v /etc/ssh/ssh_host_ed25519_key:/etc/ssh/ssh_host_ed25519_key:ro \
        -v /root/.ssh/authorized_keys:/root/.ssh/authorized_keys:ro \
        -v $HOME/Downloads/sources/:/sources/:rw \
        -v $HOME/Downloads/sources/pacman-cache-x64:/var/cache/pacman/pkg/:rw \
        --env="DISPLAY" \
        --env="QT_X11_NO_MITSHM=1" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        -h docker \
        -p 2222:22 \
        --name myarchlidar \
        ${MYUSER}/archlidar-${MYARCH}

    # test clinet
    ssh -CY -p 2222 root@localhost


    # mount the data valumn
    sudo nvidia-docker run \
        -d \
        -i -t \
        --privileged \
        -v /etc/ssh/ssh_host_key:/etc/ssh/ssh_host_key:ro \
        -v /etc/ssh/ssh_host_rsa_key:/etc/ssh/ssh_host_rsa_key:ro \
        -v /etc/ssh/ssh_host_dsa_key:/etc/ssh/ssh_host_dsa_key:ro \
        -v /etc/ssh/ssh_host_ecdsa_key:/etc/ssh/ssh_host_ecdsa_key:ro \
        -v /etc/ssh/ssh_host_ed25519_key:/etc/ssh/ssh_host_ed25519_key:ro \
        -v /root/.ssh/authorized_keys:/root/.ssh/authorized_keys:ro \
        -v $HOME/Downloads/sources/:/sources/:rw \
        -v $HOME/Downloads/sources/pacman-cache-x64:/var/cache/pacman/pkg/:rw \
        -v /media/yhfu/yhfu2tdata/cuda-lidar/:/data/:rw \
        -h docker \
        -p 2222:22 \
        --name myarchlidar \
        ${MYUSER}/archlidar-${MYARCH}







sudo nvidia-docker run \
        --rm \
        -i -t \
        --privileged \
        -v /etc/ssh/ssh_host_key:/etc/ssh/ssh_host_key:ro \
        -v /etc/ssh/ssh_host_rsa_key:/etc/ssh/ssh_host_rsa_key:ro \
        -v /etc/ssh/ssh_host_dsa_key:/etc/ssh/ssh_host_dsa_key:ro \
        -v /etc/ssh/ssh_host_ecdsa_key:/etc/ssh/ssh_host_ecdsa_key:ro \
        -v /etc/ssh/ssh_host_ed25519_key:/etc/ssh/ssh_host_ed25519_key:ro \
        -v /root/.ssh/authorized_keys:/root/.ssh/authorized_keys:ro \
        -v $HOME/Downloads/sources/:/sources/:rw \
        -v $HOME/Downloads/sources/pacman-cache-x64:/var/cache/pacman/pkg/:rw \
        --env="DISPLAY" \
        --env="QT_X11_NO_MITSHM=1" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        -h docker \
        -p 2222:22 \
        --name myarchlidar \
        ${MYUSER}/archlidar-${MYARCH}
