#!/usr/bin/env bash
set -ex

# TODO: Preload MobSF image to decrease init time. Blocker: Using Sysbox runtime during build doesn't seem to work.
# File not currently used: Modified from Sysbox quickstart; doesn't work...
# https://github.com/nestybox/sysbox/blob/master/docs/quickstart/images.md

# dockerd start
dockerd > /var/log/dockerd.log 2>&1 &
sleep 2

# pull inner images
docker pull opensecurity/mobile-security-framework-mobsf:latest

# TODO: Potentially move container creation (not start) here, pending solution to Sysbox blocker. docker create ...

# dockerd cleanup (remove the .pid file as otherwise it prevents
# dockerd from launching correctly inside sys container)
kill $(cat /var/run/docker.pid)
kill $(cat /run/docker/containerd/containerd.pid)
rm -f /var/run/docker.pid
rm -f /run/docker/containerd/containerd.pid
