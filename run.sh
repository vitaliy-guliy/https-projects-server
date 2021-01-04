#!/bin/bash
#
# Copyright (c) 2018 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0

files_dir='/home/vitaliy/projects/zip-projects/httpd-dockerimage/node-dev/https-server/files'

# cert_pem='/home/vitaliy/projects/zip-projects/httpd-dockerimage/node-dev/https-server/cert/cert.pem'
# key_pem='/home/vitaliy/projects/zip-projects/httpd-dockerimage/node-dev/https-server/cert/key.pem'

cert_pem='/tmp/cert/ca.crt'
key_pem='/tmp/cert/ca.key'

server_name='vitaliy-ThinkPad-P50'

http-server ${files_dir} \
    -p 9090 \
    -a ${server_name} \
    -S \
    -C ${cert_pem} \
    -K ${key_pem}

# DOWNLOAD FILE

# curl --output greeting-extension.zip https://vitaliy-thinkpad-p50:9090/projects/greeting-extension.zip
# --cacert <file> CA certificate to verify peer against
