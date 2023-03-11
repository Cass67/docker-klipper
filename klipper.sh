#!/usr/bin/env bash
 
docker run \
    -v /dev:/dev \
    -v "/home/cass/git/3d_print_server/klipper/config/printer.cfg":/home/klippy/printer_data/config/printer.cfg \
    -v "/home/cass/git/3d_print_server/klipper/config/fluidd.cfg":/home/klippy/printer_data/config/fluidd.cfg \
    -v "/home/cass/git/3d_print_server/klipper/config/mainsail.cfg":/home/klippy/printer_data/config/mainsail.cfg \
    -v "/home/cass/git/3d_print_server/klipper/klipper.log":/home/klippy/logs/klipper.log \
    -v /dev/ttyUSB0:/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0 \
    --name klipper \
    --tmpfs /tmp \
    --tmpfs /run \
    --tmpfs /run/lock \
    --privileged \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    klipper
