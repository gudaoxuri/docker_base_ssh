FROM centos:latest
MAINTAINER gudaoxuri

#---------------Use 163 mirrors---------------
RUN yum install -y wget &&\
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup && \
    wget -P /etc/yum.repos.d/ http://mirrors.163.com/.help/CentOS7-Base-163.repo && \
    yum clean all && \
    yum makecache

#---------------Install Common Tools---------------
RUN yum install -y sed curl tar gcc gcc-c++ make git passwd sudo

#---------------Modify Time Zone---------------
ENV TZ "Asia/Shanghai"
ENV TERM xterm

RUN yum install -y ntpdate  && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#---------------Support Chinese---------------
#RUN yum groupinstall -y "Fonts"  && \
#    echo "LANG=\"zh_CN.UTF-8\"" >> /etc/sysconfig/i18n

#---------------Install SSH---------------
RUN yum install -y openssh-server openssh-clients  && \
    sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config  && \
    echo 'root:123456' | chpasswd  && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key  && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key  && \
    mkdir /var/run/sshd

#---------------Setting Common Path---------------
RUN chmod 777 -R /opt/  && \
    mkdir /opt/env/  && \
    mkdir /opt/workspaces/

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
