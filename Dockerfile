FROM base/archlinux

RUN pacman --noconfirm -Sy rsync sudo ca-certificates bash wget openssh unzip openssl && \
    echo "%root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    rm -rf /tmp/* /var/cache/pacman/pkg/* && \
    useradd user -d /home/user -m -s /bin/bash -G root -u 1000 && \
    echo "%root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    usermod -p "*" user && \
    sudo chown -R user /home/user/ && \
    sudo chgrp -R 0 /home/user/ && \
    sudo chmod -R g+rwX /home/user/

# fakse os-release for condenvy.io
RUN pacman --noconfirm -Sy sed && \
    sed -i -E 's/ID=.*/ID=alpine/g' /etc/os-release

EXPOSE 22 8000 8080

USER user

CMD sudo /usr/bin/ssh-keygen -A && \
    sudo /usr/sbin/sshd -D && \
    sudo su - && \
    tail -f /dev/null
