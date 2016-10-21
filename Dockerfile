#ARG MYARCH
FROM yhfu/archsshd-x86_64
MAINTAINER yhfu <yhfudev@gmail.com>

# MOUNT cgroup:/sys/fs/cgroup/ # Rockerfile
# MOUNT pacman:/var/cache/pacman/pkg/ # Rockerfile
VOLUME [ "/sys/fs/cgroup" ]

RUN pacman -Syyu --needed --noconfirm

# install dependants
RUN pacman -S --noprogressbar --noconfirm --needed lsb-release file base-devel abs fakeroot pkgfile community/pkgbuild-introspection wget git mercurial subversion cvs bzip2 unzip vim cmake make; pkgfile --update

RUN pacman -S --noprogressbar --noconfirm --needed \
        gtest libgl eigen boost vtk qhull openmpi gl2ps \
        gstreamer0.10-base openexr xine-lib libdc1394 gtkglext nvidia-utils hdf5-cpp-fortran python cuda libcl intel-tbb \
        gcc gcc5 gdb python2-numpy python-numpy mesa \
        gdal postgresql-libs libmysqlclient unixodbc

RUN sed -i -e 's/^#MAKEFLAGS.*/MAKEFLAGS="-j16"/g' /etc/makepkg.conf

USER docker
# clean up
RUN sudo rm -rf /home/docker/*

RUN yaourt -Syyua --noconfirm --needed ceres-solver
RUN yaourt -Syyua --noconfirm --needed glog ; \
    yaourt -Syyua --noconfirm --needed gflags
RUN yaourt -Syyua --noconfirm --needed pcl
RUN yaourt -Syyua --noconfirm --needed libisam


# nvidia-docker hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

RUN sudo pacman -S --noprogressbar --noconfirm --needed \
        python2 python2-yaml python2-nose python2-paramiko python2-netifaces python2-pip \
        pkg-config jshon boost libyaml \
        ninja

# ATTACH # Rockerfile

# updated opencv witch opencv_contrib and CUDA
RUN yaourt -Syyua --noconfirm --needed opencv-cuda-git

# dependants for ros-jade-rviz
RUN sudo pacman -S --noprogressbar --noconfirm --needed \
  ogre \
  assimp \
  eigen3 \
  tinyxml \
  mesa \
  yaml-cpp

# updated ros-jade-python-qt-binding with qt5
RUN git clone https://github.com/yhfudev/pacman-ros-jade-python-qt-binding.git \
    && cd pacman-ros-jade-python-qt-binding \
    && makepkg -Asf \
    && pacman -U ros-jade-python-qt-binding*.pkg.tar.xz


RUN echo \
  ros-jade-roslib \
  ros-jade-roscpp \
  ros-jade-tf \
  ros-jade-resource-retriever \
  ros-jade-message-filters \
  ros-jade-visualization-msgs \
  ros-jade-image-geometry \
  ros-jade-cmake-modules \
  ros-jade-geometry-msgs \
  ros-jade-image-transport \
  ros-jade-rospy \
  ros-jade-map-msgs \
  ros-jade-std-msgs \
  ros-jade-std-srvs \
  ros-jade-rosbag \
  ros-jade-pluginlib \
  ros-jade-laser-geometry \
  ros-jade-interactive-markers \
  ros-jade-urdf \
  ros-jade-sensor-msgs \
  ros-jade-nav-msgs \
  ros-jade-catkin \
  ros-jade-rosconsole \
  ros-jade-media-export \
  | xargs -n 1 yaourt -Syyua --noconfirm --needed

# updated ros-jade-rviz with qt5
#RUN yaourt -Syyua --noconfirm --needed ros-jade-rviz
RUN git clone https://github.com/yhfudev/pacman-ros-jade-rviz.git \
    && cd pacman-ros-jade-rviz \
    && makepkg -Asf \
    && pacman -U ros-jade-rviz*.pkg.tar.xz

# install all:
# yaourt -Syyua --noconfirm --needed ros-jade-desktop-full

USER root
RUN rm -rf /home/docker/*

# start the server (goes into the background)
#CMD /usr/bin/sshd; sleep infinity
#CMD ["/usr/sbin/init"]
ENTRYPOINT ["/lib/systemd/systemd"]

# PUSH yhfu/archlidar:latest # Rockerfile

