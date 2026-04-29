#! /bin/bash

# Check dependencies
command -v inkscape >/dev/null 2>&1 || { echo >&2 "I require inkscape but it's not installed. Aborting."; exit 1; }
command -v scour >/dev/null 2>&1 || { echo >&2 "I require scour but it's not installed. Aborting."; exit 1; }

# Delete current icons to re-monochrome (yes, despite how long this takes, its a necessary evil)
rm -rf app/src/monochromatic/res/drawable-mdpi
rm -rf app/src/monochromatic/res/drawable-hdpi
rm -rf app/src/monochromatic/res/drawable-xhdpi
rm -rf app/src/monochromatic/res/drawable-xxhdpi
rm -rf app/src/monochromatic/res/drawable-xxxhdpi

# recreate the now empty folders
if [[ ! -e app/src/monochromatic/res/drawable-mdpi ]]; then
    mkdir -p app/src/monochromatic/res/drawable-mdpi
fi
if [[ ! -e app/src/monochromatic/res/drawable-hdpi ]]; then
    mkdir -p app/src/monochromatic/res/drawable-hdpi
fi
if [[ ! -e app/src/monochromatic/res/drawable-xhdpi ]]; then
    mkdir -p app/src/monochromatic/res/drawable-xhdpi
fi
if [[ ! -e app/src/monochromatic/res/drawable-xxhdpi ]]; then
    mkdir -p app/src/monochromatic/res/drawable-xxhdpi
fi
if [[ ! -e app/src/monochromatic/res/drawable-xxxhdpi ]]; then
    mkdir -p app/src/monochromatic/res/drawable-xxxhdpi
fi

for SVG in icons/monochromatic/*.svg
do
    if [[ -f "${SVG}" ]]; then
        N=$(basename ${SVG} .svg)
        echo "Exporting ${SVG}..."

        # Reuse the same inkscape process to export all resolutions, it's a bit gross to read but its much faster!
        ACTIONS=$(cat <<-END
export-width:48; export-height:48; export-filename:app/src/monochromatic/res/drawable-mdpi/${N}.png; export-do;\
export-width:72; export-height:72; export-filename:app/src/monochromatic/res/drawable-hdpi/${N}.png; export-do;\
export-width:96; export-height:96; export-filename:app/src/monochromatic/res/drawable-xhdpi/${N}.png; export-do;\
export-width:144; export-height:144; export-filename:app/src/monochromatic/res/drawable-xxhdpi/${N}.png; export-do;\
export-width:192; export-height:192; export-filename:app/src/monochromatic/res/drawable-xxxhdpi/${N}.png; export-do;
END
)
        inkscape --actions="${ACTIONS}" ${SVG}
    fi
done

scour_svg() {
    SVG=$1
    if [[ -f "${SVG}" ]]; then
        cp ${SVG} ${SVG}.tmp
        scour --remove-descriptive-elements --enable-id-stripping --enable-viewboxing --enable-comment-stripping --nindent=4 -i ${SVG}.tmp -o ${SVG}
        rm ${SVG}.tmp
    fi
}

export -f scour_svg

# Inkscape doesn't like running multiple jobs at once so we can't reliably parallelize it
parallel scour_svg ::: icons/monochromatic/*.svg
