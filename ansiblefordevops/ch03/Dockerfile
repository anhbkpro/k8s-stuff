FROM geerlingguy/docker-rockylinux8-ansible:latest

RUN dnf install -y openssh-server openssh-clients && \
    dnf clean all && \
    ssh-keygen -A && \
    mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    systemctl enable sshd

COPY .vagrant_insecure_key.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

EXPOSE 22
