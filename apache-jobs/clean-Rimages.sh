# -------------------------------------------------------------------
# - NAME:        clean-Rimages.sh
# - AUTHOR:      Reto Stauffer
# - DATE:        2014-12-28
# -------------------------------------------------------------------
# - DESCRIPTION:
# -------------------------------------------------------------------
# - EDITORIAL:   2014-12-28, RS: Created file on thinkreto.
# -------------------------------------------------------------------
# - L@ST MODIFIED: 2014-12-28 12:51 on prognose2.met.fu-berlin.de
# -------------------------------------------------------------------


# - Cleaning svg images from /var/www/html/Rimages/. Kill all of them.
set -u

# - User has to be apache
if [ $USER != 'apache' ] ; then
   echo "Sorry, script has to be started as the apache user"
   exit 9
fi

# - Else delete all files
DIR='/var/www/html/Rimages'
find $DIR -name '*.svg' -exec rm {} \;
