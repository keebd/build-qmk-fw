FROM ghcr.io/qmk/qmk_cli:latest
RUN qmk setup https://github.com/keebd/qmk_firmware.git -y -H /opt/qmk_firmware
RUN cd /opt/qmk_firmware && git checkout keebd
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
