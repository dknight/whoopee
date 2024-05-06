#!/bin/bash

# build
jenny


echo "Uploading.."

# upload
rclone sync .dist ftp.whoop.ee:/public_html

echo "OK"

