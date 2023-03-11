
# Container for klipper
#
# -- build container as per whatever arch is needed --
# docker buildx build --platform linux/amd64 -t klipper .   # << x86
# docker buildx build --platform linux/aarch64 -t klipper . # << m1 mac
#
# or if you dont care about arch related stuff
#
# docker build -t klipper .
#
# -- export container for another system --
# docker save -o klipper.tar klipper
# gzip klipper.tar
#
#
# -- RUN --
#     docker run \
#       -v /dev:/dev \
#       -v "/home/cass/home_klippy/klippy":/home/klippy \
#       -v /dev/ttyUSB0:/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0 \
#       --name klipper \
#       -p 80:80 \
#       -p 81:81 \
#       -p 5000:5000 \
#       -p 7125:7125 \
#       -p 8080:8080 \
#       --tmpfs /tmp \
#       --tmpfs /run \
#       --tmpfs /run/lock \
#       --privileged \
#       -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
#       klipper
# }



FROM debian:10

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

# Install systemd dependencies + sudo/git
RUN apt-get update \
    && apt-get install -y \
    procps \
    vim \
    virtualenv \
    python-dev \
    libffi-dev \
    build-essential \
    libncurses-dev \
    libusb-dev \
    avrdude \
    gcc-avr \ 
    binutils-avr \ 
    avr-libc \
    stm32flash \ 
    libnewlib-arm-none-eabi \
    gcc-arm-none-eabi \
    binutils-arm-none-eabi \ 
    libusb-1.0 pkg-config \
    git \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Create user
RUN useradd -ms /bin/bash klippy && adduser klippy dialout
USER root
RUN echo 'klippy ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers

USER klippy
#This fixes issues with the volume command setting wrong permissions
RUN mkdir -p /home/klippy/.config /home/klippy/printer_data/config /home/klippy/logs
VOLUME /home/klippy/.config

ENV HOMEDIR=/home/klippy
### Klipper setup ###
WORKDIR /home/klippy
USER klippy
RUN git clone https://github.com/Klipper3d/klipper.git
COPY requirements.txt .
RUN pip3 install -r requirements.txt

ENTRYPOINT ["/usr/bin/python3", "/home/klippy/klipper/klippy/klippy.py", "/home/klippy/printer_data/config/printer.cfg"]
