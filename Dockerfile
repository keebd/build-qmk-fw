FROM ghcr.io/qmk/qmk_cli:latest
RUN qmk setup -y -H /opt/qmk_firmware
RUN git clone --recurse-submodules -j8 git://github.com/vial-kb/vial-qmk.git /opt/vial-qmk
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
