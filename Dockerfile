FROM centos
MAINTAINER gudaoxuri

RUN yum install -y wget &&\
    yum clean all && \
    yum makecache

#---------------Install Common Tools---------------
RUN yum install -y sed curl tar gcc gcc-c++ make git passwd sudo

#---------------Modify Time Zone---------------
ENV TZ "Asia/Shanghai"
ENV TERM xterm
k
RUN yum install -y ntpdate  && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#---------------Install SSH---------------
RUN yum install -y openssh-server openssh-clients  && \
    sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config  && \
    echo 'root:123456' | chpasswd  && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key  && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key  && \
    mkdir /var/run/sshd

RUN echo "Host *" >> /etc/ssh/ssh_config
RUN echo " StrictHostKeyChecking no" >> /etc/ssh/ssh_config

#---------------Setting Common Path---------------
RUN chmod 777 -R /opt/  && \
    mkdir /opt/env/  && \
    mkdir /opt/workspaces/

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
