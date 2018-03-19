#!/bin/bash -e

pwd

mkdir -p ~/code ~/code/nginx-configs

# Copy all applications nginx files into a single directory.
cp ~/code/*/web-env/*.conf ~/code/nginx-confs/