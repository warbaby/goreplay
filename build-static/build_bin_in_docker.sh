#! /bin/bash

#sed -i 's#http://deb.debian.org#https://mirrors.163.com#g' /etc/apt/sources.list
sed -i 's#http://deb.debian.org#https://mirrors.ustc.edu.cn#g' /etc/apt/sources.list
apt update

# install dependencies to build libpcap
apt install -y bison flex


# build libpcap as static lib
tar -xzvf ./build/libpcap-1.10.1.tar.gz
cd libpcap-1.10.1 || exit 1
./configure --disable-shared
make install
cd ..
rm -rfv libpcap-1.10.1

export CGO_LDFLAGS="-L/usr/local/lib -lpcap -static -lrt"
go build -mod=vendor -o gor -buildvcs=false -tags netgo,osusergo -ldflags "-extldflags '-static -pthread'" ./cmd/gor/