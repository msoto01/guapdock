# Dockerfile Compose for Guapcoin because the documentation sucks @$$
FROM debian:latest

# Update base Debian image

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get dist-upgrade -y

# Add prerequisites for Guapcoin

RUN apt-get install build-essential libtool bsdmainutils autotools-dev autoconf pkg-config automake python3 -y
RUN apt-get install libssl-dev libgmp-dev libevent-dev libboost-all-dev -y

# UPnP Support

RUN apt-get install libminiupnpc-dev -y

# ZMQ API Support

RUN apt-get install libzmq3-dev -y

# QT5 GUI support 

RUN apt-get install libqt5gui5 libqt5core5a libqt5dbus5 libqt5svg5-dev libqt5charts5-dev qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler libqrencode-dev -y

# Clone and Build Guapcoin from Github

RUN apt-get install wget git -y
RUN git clone https://github.com/guapcrypto/Guapcoin.git && cd Guapcoin && chmod 777 ./contrib/install_db4.sh && ./contrib/install_db4.sh `pwd` && ./autogen.sh && export BDB_PREFIX='/Guapcoin/db4' && ./configure BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx-4.8" BDB_CFLAGS="-I${BDB_PREFIX}/include" && make && make install

# Expose for Guapcoin Ports: RPC Port : 9634, P2P Port : 9633

EXPOSE 9634
EXPOSE 9633

# Install X11 and Launch Guapcoin GUI
WORKDIR Guapcoin/src
RUN apt-get install xorg -y && startx && guapcoin-qt
