FROM ghcr.io/qmk/qmk_cli:latest
RUN qmk setup keebd/qmk_firmware -y -H /opt/qmk_firmware
RUN git clone --recurse-submodules -j8 https://github.com/vial-kb/vial-qmk.git /opt/vial-qmk
RUN cd /opt/vial-qmk && git checkout keebd
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
