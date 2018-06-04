#!/bin/bash -e

cat /root/env-vars.txt >> /root/.bashrc
source /root/.bashrc

# clean-up
rm /root/env-vars.txt