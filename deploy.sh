#!/bin/bash

status=0
rm -f .bloglock
DEPLOY=1 jenny
echo "[rclone] Uploading..."
rclone sync .dist whoopee:/public_html
status=$?
if [[ $status -eq 0 ]]; then
	echo "[rclone] OK"
else
	echo "[rclone] Error"
fi
