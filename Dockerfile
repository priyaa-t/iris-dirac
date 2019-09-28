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
# Install Singularity dependencies and Go
RUN yum groupinstall -y 'Development Tools' && \
    yum install -y \
                openssl-devel \
                libuuid-devel \
                libseccomp-devel \
                squashfs-tools
RUN export VERSION=1.13.1 OS=linux ARCH=amd64 && \
    wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && \
    tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz && \
    rm go$VERSION.$OS-$ARCH.tar.gz && \
    echo 'export PATH=/usr/local/go/bin:${PATH}' >> /etc/profile && \
    source /etc/profile

# Download Singularity
RUN export VERSION=3.2.0 && \
    wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz && \
    tar -xzf singularity-${VERSION}.tar.gz
# Install Singularity
RUN cd singularity && \
    source /etc/profile && \
    ./mconfig && \
    make -C ./builddir && \
    make -C ./builddir install

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
