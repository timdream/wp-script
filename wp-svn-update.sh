svn switch http://core.svn.wordpress.org/tags/$2 $1
eval "svn propset svn:externals 'languages http://svn.automattic.com/wordpress-i18n/zh_TW/branches/"$3"/messages' "$1"/wp-content"
svn update $1/wp-content
