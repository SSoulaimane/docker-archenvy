FROM base/archlinux

RUN pacman --noconfirm -Sy rsync sudo ca-certificates bash wget openssh unzip openssl && \
    echo "%root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    rm -rf /tmp/* /var/cache/pacman/pkg/* && \
    useradd user -d /home/user -s /bin/bash -G root -u 1000 && \
    echo "%root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    usermod -p "*" user && \
    sudo chown -R user /home/user/ && \
    sudo chgrp -R 0 ${HOME} && \
    sudo chmod -R g+rwX ${HOME}

# fakse os-release for condenvy.io
RUN pacman --noconfirm -Sy sed && \
    sed -i -E 's/ID=.*/ID=alpine/g' /etc/os-release

USER user

CMD sudo /usr/bin/ssh-keygen -A && \
    sudo /usr/sbin/sshd -D && \
    sudo su - && \
    tail -f /dev/null
