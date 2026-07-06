# Base image pinned by digest for reproducible builds; Renovate bumps it via PR.
FROM ghcr.io/qmk/qmk_cli:latest@sha256:b7d7fa8fb4432b569931de5ad59098cb788f440ed61a62c5126746b71aee0f4a
RUN qmk setup keebd/qmk_firmware -y -H /opt/qmk_firmware
RUN cd /opt/qmk_firmware && git checkout keebd
# Install the checked-out (keebd) branch's Python deps into the environment the
# qmk CLI actually uses. Recent qmk_cli images manage the CLI with uv, so its
# interpreter is /opt/uv/tools/qmk/bin/python3 -- NOT the system python.
RUN /opt/uv/tools/qmk/bin/python3 -m pip install -r /opt/qmk_firmware/requirements.txt
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
