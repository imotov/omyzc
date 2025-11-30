#!/usr/bin/env zsh

IMAGE_NAME="mutb:latest"
OS=$(uname)

if [[ $OS == "Darwin" ]]; then
    if command -v docker >/dev/null 2>&1; then
        if docker system info >/dev/null 2>&1; then
            if [[ -n "$(docker image ls -q "$IMAGE_NAME")" ]]; then
                mutb() {
                    docker run --rm \
                        -v "$PWD":"$PWD" \
                        -w "$PWD" \
                        --user "$(id -u):$(id -g)" \
                        mutb:latest "$@"
                }
                exiftool() {
                    mutb exiftool "$@"
                }
                fixexif() {
                    exiftool "-filemodifydate<datetimeoriginal" `find . -type f -newermt "00:00 today"`
                }
            fi
        fi
    fi
fi    


