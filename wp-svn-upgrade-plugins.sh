#!/usr/bin/env bash

if [ -z $1 ]; then
  echo 'Usage: '$0' [WordPress root dir]'
  exit 1
fi

if [ -z ${TMPDIR} ]; then
  TMPDIR=/tmp/
fi

WP_DIR=$1

svn propget svn:externals ${WP_DIR}/wp-content/plugins > ${TMPDIR}externals.list.orig
EXTERNAL_LIST=`cat ${TMPDIR}externals.list.orig`

rm -f ${TMPDIR}externals.list

for i in ${EXTERNAL_LIST}; do
  if [ -z ${DIRNAME} ]; then
    DIRNAME=$i
    continue
  fi

  URL=$i

  # echo -n ${DIRNAME}", "${URL}

  if [ -z `echo ${URL} | grep \/tags\/` ]; then
    # echo ", skipping."
    echo ${DIRNAME}" "${URL} >> ${TMPDIR}externals.list
    DIRNAME=
    continue
  fi

  URL_WITHOUT_VER=`echo ${URL} | sed -E "s/tags\/.+/tags\//g"`
  VER=`wget -q ${URL_WITHOUT_VER} -O - | grep "<li>" | sed -E "s/(<[^>]+>| |\/)//g" | sort -n -t. -k 1,1n -k 2,2n -k 3,3n | tail -n 1`

  # echo ", -> "$VER
  echo ${DIRNAME}" "${URL_WITHOUT_VER}${VER} >> ${TMPDIR}externals.list
  DIRNAME=
done

diff ${TMPDIR}externals.list.orig ${TMPDIR}externals.list

echo "Confirm upgrades?"
read

eval "svn propset svn:externals '`cat ${TMPDIR}externals.list`' ${WP_DIR}/wp-content/plugins"
svn update ${WP_DIR}/wp-content/plugins
