if [ -z $1 ]; then
	echo 'Usage: '$0' [WordPress root dir]'
	exit 1
fi

mkdir -p $1 > /dev/null

VER_CHECK='http://api.wordpress.org/core/version-check/1.4/'
LANG='zh_TW'

echo
echo '* Checking latest WordPress version...'
WP_VER=`wget -q $VER_CHECK -O - | head -n 4 | tail -1`
echo 'Latest WordPress version: '$WP_VER
L10N_VER=`wget -q $VER_CHECK?locale=$LANG -O - | head -n 4 | tail -1`
echo 'Latest '$LANG' version: '$L10N_VER
echo

echo '* Installing WordPress files through subversion...'
svn co http://core.svn.wordpress.org/tags/$WP_VER $1
echo

echo '* Verify the existence of l10n repo with tagged version...'
L10N_REPO=http://svn.automattic.com/wordpress-i18n/$LANG/tags/$L10N_VER/messages
wget $L10N_REPO -q -O - > /dev/null
if [ $? -ne 0 ]; then
	echo 'Warning: l10n repo with '$L10N_VER' tag does not exist, using files in trunk instead.'
	L10N_REPO=http://svn.automattic.com/wordpress-i18n/$LANG/trunk/messages
fi
echo

echo '* Installing l10n files through subversion...'
eval "svn propset svn:externals 'languages $L10N_REPO' "$1"/wp-content"
svn update $1/wp-content
echo

echo "
\$wp_local_package = '$LANG';" >> $1/wp-includes/version.php

echo 'Done.'