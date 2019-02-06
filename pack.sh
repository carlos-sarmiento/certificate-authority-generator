#!/bin/bash

tar --exclude='./*.sh' \
    --exclude='./*.template' \
    --exclude='./README.md' \
    --exclude='./.gitignore' \
    --exclude='./.git' \
    --exclude='./packed-ca.tgz' \
    -pzcvf packed-ca.tgz .
