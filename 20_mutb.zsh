#!/usr/bin/env zsh

IMAGE_NAME="mutb:latest"
OS=$(uname)

if [[ $OS == "Darwin" ]]; then
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
    fdupes() {
        mutb fdupes "$@"
    }
    find_dup_footage() {
        fdupes . -r | grep "^\./Footage" -v ".DS_Store" | sort 
    }
fi    


