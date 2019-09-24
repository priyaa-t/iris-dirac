FROM centos:7

RUN yum -y update
# Repositories
RUN yum -y install epel-release

# Packages we need or want
RUN yum -y install emacs \
                   joe \
                   less \
                   man \
                   man-pages \
                   man-pages-overrides \
                   nano \
                   openssl \
                   python-pip \
                   pugixml \
                   wget \
                   vim
RUN pip install future
RUN mkdir /usr/local/gridpp-dirac && \
    cd /usr/local/gridpp-dirac && \
    wget -np -O dirac-install https://raw.githubusercontent.com/DIRACGrid/DIRAC/integration/Core/scripts/dirac-install.py && \
    chmod +x dirac-install && \
    ./dirac-install -r v6r21p7 -i 27 -g v14r1 && \ 
    source ./bashrc 
RUN echo "alias setup-grid='source /usr/local/gridpp-dirac/bashrc'" > /etc/profile.d/gridpp-dirac.sh

# Add a non-privileged user
RUN useradd --create-home --skel /dev/null user
