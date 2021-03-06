#!/bin/sh

if [ -z $1 ]; then
	echo 'Usage: '$0' [WordPress root dir]'
	exit 1
fi

if [ ! -d $1/.svn ]; then
	echo 'Error: '$1' is not a subversion-managed WordPress.'
	echo 'Please install WordPress with wp-svn-install at first place.'
	echo 'You could convert your tarball WordPress into svn WordPress by copying config and uploaded/changed files into it.'
	exit 1
fi

if [ -z $PROTOCOL ]; then
  PROTOCOL=https
fi

VER_CHECK=${PROTOCOL}'://api.wordpress.org/core/version-check/1.4/'
if [ ! -z $WP_LANG ]; then
  WP_LANG=`echo 'echo $wp_local_package;' | cat $1/wp-includes/version.php - | php 2>/dev/null`
fi

echo '* Checking latest WordPress version...'
WP_VER=`wget -q $VER_CHECK -O - | head -n 4 | tail -1`
if [ -z $WP_VER ]; then
  echo
  echo 'Error: Unable to get the latest version number.'
  echo 'Maybe you should switch the PROTOCOL to http?'
  exit;
fi

echo 'Latest WordPress version: '$WP_VER

if [ ! -z $WP_LANG ]; then
  L10N_VER=`wget -q $VER_CHECK?locale=$WP_LANG -O - | head -n 4 | tail -1`
  echo 'Latest '$WP_LANG' version: '$L10N_VER
fi

echo

echo '* Upgrading WordPress files through subversion...'
svn switch ${PROTOCOL}://core.svn.wordpress.org/tags/$WP_VER $1
echo

if [ ! -z $WP_LANG ]; then
  echo '* Verify the existence of l10n repo with tagged version...'
  L10N_REPO=${PROTOCOL}://svn.automattic.com/wordpress-i18n/$WP_LANG/tags/$L10N_VER/dist/wp-content/languages
  wget $L10N_REPO -q -O - > /dev/null
  if [ $? -ne 0 ]; then
    echo 'Warning: l10n repo with '$L10N_VER' tag does not exist, using files in trunk instead.'
    L10N_REPO=${PROTOCOL}://svn.automattic.com/wordpress-i18n/$WP_LANG/trunk/dist/wp-content/languages
  fi
  echo

  echo '* Upgrading l10n files through subversion...'
  eval "svn propset svn:externals 'languages $L10N_REPO' "$1"/wp-content"
  svn update $1/wp-content
  echo
fi

echo 'Done.'
