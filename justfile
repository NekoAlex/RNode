#!/usr/bin/env just --justfile

build:
  docker build --tag rnode_build --output=./build .


upload:
  "/Users/nekoalex/Library/Arduino15/packages/esp32/tools/esptool_py/4.5.1/esptool" \
    --chip esp32 \
    --port "/dev/tty.usbserial-53230062501" \
    --baud 115200  \
    --before default_reset \
    --after hard_reset write_flash  \
    -z \
    --flash_mode dio \
    --flash_freq 80m \
    --flash_size 4MB \
    0x1000 "/Users/nekoalex/Library/Caches/arduino/sketches/CA04A5029092C639F288C433BB737D63/RNode_Firmware.ino.bootloader.bin" \
    0x8000 "/Users/nekoalex/Library/Caches/arduino/sketches/CA04A5029092C639F288C433BB737D63/RNode_Firmware.ino.partitions.bin" \
    0xe000 "/Users/nekoalex/Library/Arduino15/packages/esp32/hardware/esp32/2.0.17/tools/partitions/boot_app0.bin" \
    0x10000 "/Users/nekoalex/Library/Caches/arduino/sketches/CA04A5029092C639F288C433BB737D63/RNode_Firmware.ino.bin"


clean:
  rm -rf build/
  docker builder prune --force

init-EEPROM:
  python3 ./Release/esptool/esptool.py \
    --chip esp32 \
    --port "/dev/tty.usbserial-53230062501" \
    --baud 115200 \
    --before default_reset \
    --after hard_reset write_flash \
    -z \
    --flash_mode dio \
    --flash_freq 80m \
    --flash_size 4MB \
    0x210000 ./Release/console_image.bin


#python3 /Users/nekoalex/Library/Python/3.9/lib/python/site-packages/RNS/Utilities/rnodeconf.py
#python3 loramon.py /dev/tty.usbserial-53230062501 --console --freq 869075000 --bw 250000 --sf 128 --cr 5
