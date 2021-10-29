#!/bin/bash
set -e
export LD_LIBRARY_PATH="/mjpg-streamer/mjpg-streamer-experimental"
export ENV_FPS=${ENV_FPS:-"15"}
export ENV_RESOLUTION=${ENV_RESOLUTION:-"640x480"}
export ENV_PORT=${ENV_PORT:-"8080"}
export ENV_LOCATION=${ENV_LOCATION:-"/usr/local/www"}
export ENV_CAMERA=${ENV_CAMERA:-"/dev/video0"}

export LD_LIBRARY_PATH="/mjpg-streamer/mjpg-streamer-experimental"
./mjpg_streamer -i "input_uvc.so -r $ENV_RESOLUTION -d $ENV_CAMERA -f $ENV_FPS" -o "output_http.so -p $ENV_PORT -w $ENV_LOCATION"
