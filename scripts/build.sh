#! /bin/bash
set -e

if [[ $# -ne 4 ]]
then
    echo "Invalid arguments!"
    echo "Usage: $0 <markdown directory> <config file> <latex file directory> <output path>"
    exit -1
fi

MARKDOWN_DIR=$(realpath $1)
CONFIG_YML=$(realpath $2)
LATEX_FILES_DIR=$(realpath $3)
OUTPUT_PATH=$(realpath $4)
BASE_DIR=$(realpath `dirname $0`)/..
TEMP_DIR=$BASE_DIR/temp

cd $(dirname $0)/

function get_bin_path {
    if [[ $USE_PANDOC_IN_PATH -eq 1 ]]
    then
        export PANDOC_PATH=/usr/bin/pandoc
        export SVG_FILTER_PATH=/scripts/svg-filter.lua
    else
        cd $BASE_DIR/pandoc
        export PANDOC_PATH=$(stack path --local-install-root)/bin/pandoc
        export SVG_FILTER_PATH=$BASE_DIR/scripts/svg-filter.lua
    fi
}

function create_temp_dir {
    [ ! -d "/path/to/dir" ] || mkdir $TEMP_DIR
}

function build {
    cd $MARKDOWN_DIR
    $PANDOC_PATH --defaults $BASE_DIR/configs/default.yml --defaults $CONFIG_YML --lua-filter $SVG_FILTER_PATH
    BIBINPUTS="$LATEX_FILES_DIR:`kpsewhich -expand-braces=$(kpsewhich -var-value=BIBINPUTS)`" \
    BSTINPUTS="$LATEX_FILES_DIR:`kpsewhich -expand-braces=$(kpsewhich -var-value=BSTINPUTS)`" \
    TEXINPUTS="$LATEX_FILES_DIR:`kpsewhich -expand-braces=$(kpsewhich -var-value=TEXINPUTS)`" \
        latexmk --norc -r $BASE_DIR/configs/latexmkrc -outdir=$TEMP_DIR ./input.tex
    cp $TEMP_DIR/input.pdf $OUTPUT_PATH
    rm input.tex
}

get_bin_path
create_temp_dir
build
