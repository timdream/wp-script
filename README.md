wp-script
=========

**Author:** Timothy Guan-tin Chien <<timdream@gmail.com>>

These scripts helps you install/upgrade your WordPress installations through the official WordPress subversion repository and the localization repository.
It will detect latest version number using APIs provided by WordPress.
It is not recommended to run upgrade script using crontab unless you have written your own backup script with it.

Happy blogging. =)

## options

Options can be specified thourgh environment variable, such as

    WP_LANG=zh_TW ./wp-svn-install.sh

Available options:

* `WP_LANG`: the locale to use for the installation. The upgrade script comes with a detection command, so there is no need to specify it.
* `PROTOCOL`: The protocol to talk to WordPress servers. Default to `https`. You may switch to `http` for your own reasons.

## theme/plugins management with svn:externals

If you are comfortable using svn to do more things, you can track and update your themes and plugins with svn:externals.
`wp-svn-set-plugins.sh` and `wp-svn-set-themes.sh` will open up your default editor (set in `$EDITOR`), ask you in update the list, and set it back to the directory.
Most of the WordPress plugins/themes are tagged on `http://plugins.svn.wordpress.org/`.
You can find the URL in the Developers sections in the plugin page in WordPress Plugin/Theme Directory.
