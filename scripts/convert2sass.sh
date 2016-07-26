#! /usr/bin/env bash

# Convert Drupal Bootstrap LESS starterkit files to Sass.
# Not safe to run on modified subtheme -- may clobber files.

##############################################################################
# Functions
##############################################################################

PROGNAME=$(basename $0)

function cleanup
{
  # Delete temp files.
  find less -name '*.scss*' | xargs rm
}

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

##############################################################################
# Modify & copy Less files
##############################################################################

echo '--> converting files in less directory to scss files'

less2sass less

for i in $(find less -name '*.scss');
do
  # Replace '@media $variable' declarations.
  sed -i.bak -e 's/\@media [ ]*\(\$[a-zA-Z0-9_-]*\)/@media #{\1}/g' $i

  # Replace '&:extend(...)' with @extend ...' .
  sed -i.bak -e 's/\&:extend(\(.*\))/@extend \1/g' $i
  sed -i.bak -e 's/\(@extend.*\) all/\1/' $i

  # Prepend the include file names with '_'.
  mv $i $(dirname $i)'/_'$(basename $i);
done

echo '--> copying files to sass directory'

rsync less/ \
  sass/ \
  --exclude=*.less \
  --exclude=*.bak \
  --exclude=_bootstrap.scss \
  --exclude=_variable-overrides.scss \
  --exclude=_style.scss \
  --exclude=style.scss \
  --exclude=.DS* \
  -a


##############################################################################
# Modify and copy _variable-overrides.scss
##############################################################################

src_file='less/_variable-overrides.scss'
dest_file='sass/_variable-overrides.scss'
if [ -e $dest_file ]
then
  cleanup
  error_exit "$LINENO: $dest_file already exists.  Please delete or rename it."
else
  SEARCH="\$icon-font-path: '../bootstrap/fonts/';"
  REPLACE="\$icon-font-path: '../bootstrap/fonts/bootstrap/';"
  sed -i.bak -e "s~$SEARCH~$REPLACE~" $src_file
  cp $src_file $dest_file
fi

cleanup
