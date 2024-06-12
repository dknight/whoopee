status=0
echo "[rclone] Uploading..."
rclone sync . ftp.whoop.ee:/public_html/
status=$?
if [[ $status -eq 0 ]]; then
	echo "[rclone] OK"
else
	echo "[rclone] Error"
fi
