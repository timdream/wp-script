#!/bin/sh

if [ -z $1 ]; then
  echo 'Usage: '$0' [WordPress root dir]'
  exit 1
fi

WP_DIR=$1

if [ -z $EDITOR ]; then
  EDITOR=vim
fi

if [ -z $TMPDIR ]; then
  TMPDIR=/tmp/
fi

svn propget svn:externals ${WP_DIR}/wp-content/plugins > ${TMPDIR}externals.list

$EDITOR ${TMPDIR}externals.list

eval "svn propset svn:externals '`cat ${TMPDIR}externals.list`' '${WP_DIR}'/wp-content/plugins"
svn update ${WP_DIR}/wp-content/plugins
