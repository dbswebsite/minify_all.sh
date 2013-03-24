#!/bin/bash
#
# @file minify_all.sh
#
# A shell script that "minifies" all css and js files in the current directory and
# subdirectories by removing unneeded stuff. The resulting file(s) will have a
# .min.{js|css} filename. NOTE: This is a poor man's minifier, that well might
# miss a few things. Be sure to test files after minification!
#
# Usage: $ minify_all.sh 
#
# WARNINGS: 
# Potential Problems -- Quotes, ajax functions and line breaks
#
# This script will not ignore things in quotes! So if you have a comment inside a
# quoted string in a JavaScript file, such as document.write('//This is a comment');,
# this script will remove everything from the // and raise a JavaScript error.
#
# Also, all lines of JavaScript should end with a semicolon. This can be an issue
# with some libraries that declare functions on a line but don't end the line with a
# semicolon (as sometimes happens in ajax and jQuery scripts). For example, in: load :
# function (url, callback, format) {...} http.send( null );, there should be a
# semicolon after the function definition. This is legal JavaScript if there's a
# line break, but causes an error once minimized without the line break.
#
# @author programming@dbswebsite.com 2013-01-24
#################################################################################

function minify() {
	basename=$(echo $1 |sed -r 's/\.(js|css)//')
	suffix=$(echo $1 |sed -r 's/.*\.(js|css)/\1/')

	# do the voodoo
	cat $1 |\
		sed  -e "s|/\*\(\\\\\)\?\*/|/~\1~/|g" -e "s|/\*[^*]*\*\+\([^/][^*]*\*\+\)*/||g" \
			-e "s|\([^:/]\)//.*$|\1|" -e "s|^//.*$||" | tr '\n' ' ' | \
			sed -e "s|/\*[^*]*\*\+\([^/][^*]*\*\+\)*/||g" -e  "s|/\~\(\\\\\)\?\~/|/*\1*/|g" \
			-e "s|\s\+| |g" -e "s| \([{;:,]\)|\1|g" -e "s|\([{;:,]\) |\1|g" |\
			sed -r "s/\s+=\s+/=/g" > $basename.min.$suffix
	return 0
}

echo Looking for files to minify ...
for i in `find . -name "*.css" -o -name "*.js"`; do
	if ( echo $i|grep "\.min\." >/dev/null ); then
		# don't minify anything that is minified already
		continue
	fi
	echo minifying $i ...
	minify $i
done 

echo Done.
