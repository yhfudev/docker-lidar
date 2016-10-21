#ARG MYARCH
FROM yhfu/archopencv-x86_64
MAINTAINER yhfu <yhfudev@gmail.com>

# MOUNT cgroup:/sys/fs/cgroup/ # Rockerfile
# MOUNT pacman:/var/cache/pacman/pkg/ # Rockerfile
VOLUME [ "/sys/fs/cgroup" ]

RUN pacman -Syyu --needed --noconfirm

# dependants for ros-jade-rviz
RUN sudo pacman -S --noprogressbar --noconfirm --needed \
  ogre \
  assimp \
  eigen3 \
  tinyxml \
  mesa \
  yaml-cpp \
  python2-pyqt5

RUN yaourt -Syyua --noconfirm --needed ros-build-tools ; \
    yaourt -Syyua --noconfirm --needed ros-jade-rosbuild ; \
    yaourt -Syyua --noconfirm --needed ros-jade-catkin

# ATTACH # Rockerfile
# updated ros-jade-python-qt-binding with qt5
RUN git clone https://github.com/yhfudev/pacman-ros-jade-python-qt-binding.git \
    && cd pacman-ros-jade-python-qt-binding \
    && makepkg -Asf \
    && sudo pacman --noconfirm -U ros-jade-python-qt-binding*.pkg.tar.xz

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
    && sudo pacman --noconfirm -U ros-jade-rviz*.pkg.tar.xz

# install all:
# yaourt -Syyua --noconfirm --needed ros-jade-desktop-full

USER root
RUN rm -rf /home/docker/*
RUN pacman -Sc

# start the server (goes into the background)
#CMD /usr/bin/sshd; sleep infinity
#CMD ["/usr/sbin/init"]
ENTRYPOINT ["/lib/systemd/systemd"]

# PUSH yhfu/archlidar:latest # Rockerfile

