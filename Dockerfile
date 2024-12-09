FROM ghcr.io/qmk/qmk_cli:latest
RUN qmk setup keebd/qmk_firmware -y -H /opt/qmk_firmware
RUN /usr/bin/python3 -m pip install -r /opt/qmk_firmware/requirements.txt
RUN cd /opt/qmk_firmware && git checkout keebd
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
