#!/bin/bash

# Check if input file is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 input.mp4"
  exit 1
fi

# Input file
input="$1"

# Check if input file exists
if [ ! -f "$input" ]; then
  echo "Error: File '$input' not found"
  exit 1
fi

# Get the base name of the input file (without extension)
basename=$(basename "$input" .mp4)

# Output files
audio_output="${basename}_audio.wav"
video_output="${basename}_video.mp4"

# Extract audio as WAV
ffmpeg -i "$input" -vn -acodec pcm_s16le -ar 44100 -ac 2 "$audio_output"

# Extract video without audio
ffmpeg -i "$input" -an -vcodec copy "$video_output"

echo "Audio saved as: $audio_output"
echo "Video saved as: $video_output"
