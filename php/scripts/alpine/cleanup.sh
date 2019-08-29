#!/usr/bin/env bash

set -euf -o pipefail

apk del --purge grep build-base file openssl-dev

rm -rf \
        /tmp/* \
        /usr/includes/* \
        /usr/share/man/* \
        /usr/src/* \
        /var/cache/apk/* \
        /var/tmp/*
