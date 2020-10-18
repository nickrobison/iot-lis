# IOT-LIS

## Dev Dependencies

```bash
brew install rbenv
rbenv install
gem install bundler
bundler install
rbenv rehash
pod install
```

## Building Server OS Image

We use [go-debos](https://github.com/go-debos/debos) for building our images, this needs to be run in Ubuntu

```bash
sudo apt install golang git libglib2.0-dev libostree-dev qemu-system-x86 \
     qemu-user-static debootstrap systemd-container bmap-tools
mkdir ~/go
export GOPATH=~/go
go get -u github.com/go-debos/debos/cmd/debos
~/go/bin/debos
```
