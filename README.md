minify_all.sh
=============

A quick and dirty shell script for minifying css and js files.

A shell script that "minifies" all css and js files in the current directory and
subdirectories by removing unneeded stuff. The resulting file(s) will have a
.min.{js,css} filename. NOTE: This is a poor man's minifier, that well might miss a
few things. Test files after minification!

Usage: $ ./minify_all.sh 

WARNINGS: 

Potential Problems - quotes, ajax functions and line breaks

This script will not ignore things in quotes. So if you have a comment inside a
quote in a JavaScript file, such as document.write('//This is a comment');,
this script will remove everything from the // and raise a JavaScript error.

Also, all lines of JavaScript should end with a semicolon. This can be an issue
with some libraries that declare functions on a line but don't end the line with a
semicolon (as sometimes happens in ajax and jQuery scripts). For example, in: load :
function (url, callback, format) {...} http.send( null );, for our purposes
there should be a semicolon after the function definition. This is legal
JavaScript if there's a line break, but causes an error once minimized without
the line break. 

