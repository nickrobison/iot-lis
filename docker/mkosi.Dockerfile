FROM fedora:32

RUN dnf install -y python-pip git e2fsprogs systemd-container

RUN python3 -m pip install --user git+https://github.com/systemd/mkosi.git

ENTRYPOINT ["/usr/bin/bash"]
