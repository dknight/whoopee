#!/bin/bash

rm -y .bloglock

DEPLOY=1 jenny

echo "[rclone] Uploading..."
rclone sync .dist ftp.whoop.ee:/public_html
echo "[rclone] OK"
