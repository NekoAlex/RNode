# syntax=docker/dockerfile:1.7-labs

FROM python:3.12-slim as build

# ===== Prepare environment =====

RUN apt-get update
RUN apt-get install -y curl make
RUN pip install esptool

RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=/usr/bin sh

COPY arduino-cli.yaml Makefile /usr/src/RNode_Firmware/
WORKDIR /usr/src/RNode_Firmware/
RUN make prep-esp32

# Modify ESP32 Bluetooth buffer sizes
RUN sed -i -- 's/#define RX_QUEUE_SIZE 512/#define RX_QUEUE_SIZE 6144/g' /root/.arduino15/packages/esp32/hardware/esp32/*/libraries/BluetoothSerial/src/BluetoothSerial.cpp
RUN sed -i -- 's/#define TX_QUEUE_SIZE 32/#define TX_QUEUE_SIZE 384/g' /root/.arduino15/packages/esp32/hardware/esp32/*/libraries/BluetoothSerial/src/BluetoothSerial.cpp

# ======= Build firmware =======

COPY --exclude=justfile --exclude=Dockerfile --exclude=build --exclude=Documentation . /usr/src/RNode_Firmware/
RUN make firmware-tbeam_sx126x

FROM scratch
COPY --from=build /usr/src/RNode_Firmware/build /
