#!/bin/bash
# Runs the python http in current directory

# Some constants
HOST="127.0.0.1"
PORT="3000"

# Kill current server process if exists
kill_http_server() {
	echo "Killing process $1..."
	kill $1
	echo "HTTP Server stopped"
}
# Find running server process
ppid=$(pgrep -f "$PORT --bind $HOST")

if [[ $1 == "stop" ]]; then
	kill_http_server $ppid
	exit 0
fi

kill_http_server $ppid

# Run new server instance
python3 -m http.server $PORT --bind $HOST &

# Get the status of server, maybe will be useful in future.
server_status=$?

# Open URL in broswer
xdg-open "http://$HOST:$PORT"
