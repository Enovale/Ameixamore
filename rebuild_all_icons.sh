#!/bin/bash

# Move all existing chromatic icons to "todo" folder
mv icons/chromatic/*.svg todo

rm -rf app/src/chromatic/res/drawable-mdpi
rm -rf app/src/chromatic/res/drawable-hdpi
rm -rf app/src/chromatic/res/drawable-xhdpi
rm -rf app/src/chromatic/res/drawable-xxhdpi
rm -rf app/src/chromatic/res/drawable-xxxhdpi

# recreate the now empty folders
if [[ ! -e app/src/chromatic/res/drawable-mdpi ]]; then
    mkdir -p app/src/chromatic/res/drawable-mdpi
fi
if [[ ! -e app/src/chromatic/res/drawable-hdpi ]]; then
    mkdir -p app/src/chromatic/res/drawable-hdpi
fi
if [[ ! -e app/src/chromatic/res/drawable-xhdpi ]]; then
    mkdir -p app/src/chromatic/res/drawable-xhdpi
fi
if [[ ! -e app/src/chromatic/res/drawable-xxhdpi ]]; then
    mkdir -p app/src/chromatic/res/drawable-xxhdpi
fi
if [[ ! -e app/src/chromatic/res/drawable-xxxhdpi ]]; then
    mkdir -p app/src/chromatic/res/drawable-xxxhdpi
fi

# Process all icons
./process_all.sh
