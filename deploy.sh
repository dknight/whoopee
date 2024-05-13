#!/bin/bash

rm -y .bloglock

# build
DEPLOY=1 jenny

echo "[rclone] Uploading..."

# upload
rclone sync .dist ftp.whoop.ee:/public_html

echo "[rclone] OK"
