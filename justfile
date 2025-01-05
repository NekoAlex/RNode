#!/usr/bin/env just --justfile

build:
  docker build --tag rnode_build --output=./build .

upload:
  pass

clean:
  rm -r build/
  docker builder prune --force
