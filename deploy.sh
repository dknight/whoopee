#!/bin/bash

# build
jenny


echo "[rclone] Uploading..."

# upload
rclone sync .dist ftp.whoop.ee:/public_html

echo "[rclone] OK"

