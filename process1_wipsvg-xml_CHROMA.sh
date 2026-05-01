#! /bin/bash

# Check dependencies
command -v inkscape >/dev/null 2>&1 || { echo >&2 "I require inkscape but it's not installed. Aborting."; exit 1; }
command -v scour >/dev/null 2>&1 || { echo >&2 "I require scour but it's not installed. Aborting."; exit 1; }

for SVG in todo/*.svg
do
    if [[ -f "${SVG}" ]]; then
        N=$(basename ${SVG} .svg)
        echo "Exporting ${SVG}..."

        # Reuse the same inkscape process to export all resolutions, it's a bit gross to read but its much faster!
        ACTIONS=$(cat <<-END
export-width:48; export-height:48; export-filename:app/src/chromatic/res/drawable-mdpi/${N}.png; export-do;\
export-width:72; export-height:72; export-filename:app/src/chromatic/res/drawable-hdpi/${N}.png; export-do;\
export-width:96; export-height:96; export-filename:app/src/chromatic/res/drawable-xhdpi/${N}.png; export-do;\
export-width:144; export-height:144; export-filename:app/src/chromatic/res/drawable-xxhdpi/${N}.png; export-do;\
export-width:192; export-height:192; export-filename:app/src/chromatic/res/drawable-xxxhdpi/${N}.png; export-do;
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

        mv ${SVG} icons/chromatic
    fi
}

export -f scour_svg

# Inkscape doesn't like running multiple jobs at once so we can't reliably parallelize it
parallel scour_svg ::: todo/*.svg

# "xml" create corresponding "values/iconpack.xml" and "xml/drawable.xml"
SVGDIR="icons/chromatic/"
EXPORT="app/src/main/res"
ICPACK_PRE='        <item>'
ICPACK_SUF='</item>\n'
DRAWABLE_PRE='    <item drawable="'
DRAWABLE_SUF='" />\n'

printf '<?xml version="1.0" encoding="utf-8"?>\n<resources>\n    <string-array name="icon_pack" translatable="false">\n' > iconpack.xml
printf '<?xml version="1.0" encoding="utf-8"?>\n<resources>\n    <version>1</version>\n' > drawable.xml

for DIR in $(find ${SVGDIR} -name "*.svg" | sed "s/\.svg$//g" | sort)
do
    FILE=${DIR##*/}
    NAME=${FILE%.*}
    printf "${ICPACK_PRE}${NAME}${ICPACK_SUF}" >> iconpack.xml
    printf "${DRAWABLE_PRE}${NAME}${DRAWABLE_SUF}" >> drawable.xml
done

printf '    </string-array>\n</resources>\n' >> iconpack.xml
printf '</resources>\n' >> drawable.xml

mv -f iconpack.xml ${EXPORT}/values/
mv -f drawable.xml ${EXPORT}/xml/
