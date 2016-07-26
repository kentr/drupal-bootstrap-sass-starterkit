#! /usr/bin/env bash

# Downloads and copies the Bootstrap Sass /assets directory into
# a ./bootstrap directory

##############################################################################
# Functions
##############################################################################

PROGNAME=$(basename $0)

function error_exit
{

#   ----------------------------------------------------------------
#   Function for exit due to fatal program error
#   	Accepts 1 argument:
#   		string containing descriptive error message
#   ----------------------------------------------------------------


    echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
    exit 1
}

if [ -e bootstrap ];
then
  error_exit '$LINENO:  A bootstrap directory already exists.  Please delete or rename it first.';
fi

wget -O bootstrap-master.zip https://github.com/twbs/bootstrap-sass/archive/master.zip
unzip -q bootstrap-master.zip bootstrap-sass-master/assets/*
mv bootstrap-sass-master/assets ./bootstrap
rm -r bootstrap-sass-master bootstrap-master.zip
