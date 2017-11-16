FROM centos:7
LABEL maintainer="Jakub Jarosz"
ENV container_type=docker

# ===============================================
# Enable systemd to run inside the container
# detailed info is provided here:
# https://hub.docker.com/_centos/
# ===============================================
RUN yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for s in *; do [ $s == systemd-tmpfiles-setup.service ] || rm -f $s; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*; \
rm -f /etc/systemd/system/*.wants/*; \
rm -f /etc/systemd/system/local-fs.target.wants/*; \
rm -f /etc/systemd/system/sockets.target.wants/*udev*; \
rm -f /etc/systemd/system/sockets.target.wants/*initctl*; \
rm -f /etc/systemd/system/basic.target.wants/*; \
rm -f /etc/systemd/system/anaconda.target.wants/*;

# ===============================================
# Installing Ansible and dependencies 
# ===============================================
RUN yum makecache fast \
  && yum -y install deltarpm epel-release initscripts \
  && yum -y update \
  && yum -y install which sudo ansible \
  && yum clean all

# ===============================================
# Disabling requiretty
# ===============================================
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/' /etc/sudoers

# ===============================================
# Installing and configuring Ansible inventory 
# ===============================================
RUN echo -e '[local]\nlocalhost ansible_connection=local' >  /etc/ansible/hosts

VOLUME ["/sys/fs/cgroups"]
CMD ["/usr/sbin/init"]

