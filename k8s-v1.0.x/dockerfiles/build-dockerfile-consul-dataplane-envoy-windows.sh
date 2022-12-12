#!/usr/bin/env bash

cd ../

docker build -t docker.mirror.hashicorp.services/windows/consul-dataplane-envoy-windows:latest -f ./dockerfiles/Dockerfile-consul-dataplane-envoy-windows .