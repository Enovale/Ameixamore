#!/bin/bash

# Check optipng dependency
command -v optipng >/dev/null 2>&1 || { echo >&2 "I require optipng but it's not installed. Aborting."; exit 1; }

ICON_TYPES="chromatic monochromatic"
ICON_SIZES="drawable-mdpi drawable-hdpi drawable-xhdpi drawable-xxhdpi drawable-xxxhdpi"

OPTIPNG_OPTIONS="-preserve -quiet -o7"

export OPTIPNG_OPTIONS

optimize_png() {
    TYPE=$1
    SIZE=$2
    echo "Type: ${TYPE}; Size: ${SIZE}"
    for FILE in app/src/${TYPE}/res/${SIZE}/*.png
    do
        echo "File: ${FILE}"
        if [[ -f "${FILE}" ]]
        then
        optipng ${OPTIPNG_OPTIONS} ${FILE}
        else
        echo "Warning: File not found: ${FILE}"
        fi
    done
}

export -f optimize_png

parallel optimize_png ::: ${ICON_TYPES} ::: ${ICON_SIZES}
