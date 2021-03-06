# IOT-LIS

## Clone repo

This project makes use of [GIT LFS](https://docs.github.com/en/free-pro-team@latest/github/managing-large-files/configuring-git-large-file-storage) which means you'll need to install it before cloning.

```bash
brew install git-lfs
git clone git@github.com:nickrobison/iot-lis.git
```

## Dev Dependencies

```bash
brew install flatbuffers --HEAD # We need head until the Swift code settles down
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

## Developing on MacOS

Docker on Mac doesn't currently support Bluetooth peripherals, which makes debugging the Bluetooth logic really clunky.

The hacky solution is to create a Linux VM in [VirtualBox](https://www.virtualbox.org) or [Parallels](https://www.parallels.com) and then connect a USB Bluetooth Dongle like [this one](https://www.amazon.com/gp/product/B07J5WFPXX/ref=ppx_yo_dt_b_asin_title_o02_s00?ie=UTF8&psc=1). From there, you can easily run the server and the Bluetooth magic will work correctly.

An additional wrinkle, the iOS Simulator doesn't support Bluetooth either, so you'll need to debug on an actual device.
