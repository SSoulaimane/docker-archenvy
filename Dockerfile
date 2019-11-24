# Archlinux machine for codenvy.io

FROM archlinux/base

ENV LANG=C.UTF-8
USER root
RUN pacman --noconfirm -Sy rsync sudo ca-certificates bash wget openssh unzip grep openssl jre8-openjdk-headless && \
    echo "%root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    rm -rf /tmp/* /var/cache/pacman/pkg/* && \
    useradd user -d /home/user -m -s /bin/bash -G root -u 1000 && \
    echo "%root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    usermod -p "*" user && \
    chown -R user /home/user/ && \
    chgrp -R 0 /home/user/ && \
    chmod -R g+rwX /home/user/ && \
    echo >/etc/ssh/sshd_config && \
    echo "Port 22" >>/etc/ssh/sshd_config && \
    echo "Protocol 2" >>/etc/ssh/sshd_config && \
    echo "HostKey /etc/ssh/ssh_host_rsa_key" >>/etc/ssh/sshd_config && \
    echo "HostKey /etc/ssh/ssh_host_dsa_key" >>/etc/ssh/sshd_config && \
    echo "HostKey /etc/ssh/ssh_host_ecdsa_key" >>/etc/ssh/sshd_config && \
    echo "HostKey /etc/ssh/ssh_host_ed25519_key" >>/etc/ssh/sshd_config && \
    echo "StrictModes no" >>/etc/ssh/sshd_config && \
    echo "LogLevel INFO" >>/etc/ssh/sshd_config && \
    echo "PermitRootLogin without-password" >>/etc/ssh/sshd_config && \
    echo "PubkeyAuthentication yes" >>/etc/ssh/sshd_config && \
    echo "X11Forwarding yes" >>/etc/ssh/sshd_config && \
    echo "TCPKeepAlive yes" >>/etc/ssh/sshd_config && \
    echo "AcceptEnv LANG LC_*" >>/etc/ssh/sshd_config && \
    ln -s java-8-openjdk /usr/lib/jvm/java-1.8-openjdk

# workarrond for a bug in sudo
# credits: https://bugzilla.redhat.com/show_bug.cgi?id=1773148#c1
RUN echo "Set disable_coredump false" >/etc/sudo.conf

# pretend to be alpine to bypass condenvy.io distro checks
RUN pacman --noconfirm -Sy sed && \
    sed -i -E 's/ID=.*/ID=alpine/g' /etc/os-release

EXPOSE 22 8000 8080 4403 8081 8082 8083 8084 8085

USER user

CMD sudo /usr/bin/ssh-keygen -A && \
    sudo /usr/sbin/sshd -D && \
    sudo su - && \
    tail -f /dev/null
