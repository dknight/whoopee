#!/bin/bash

function is_index() {
	if [[ ! -z "$POST_URL" ]] || [[ ! -z "$TAGNAME" ]]; then
		echo 0
	else
		echo 1
	fi
}

function get_description() {
	contents="$POST_CONTENTS"
	if [[ -z "$contents" ]]; then
		contents="$1"
	fi
	local descr_line=$(echo "$contents" | grep -m 1 "^ *<!-- *[Dd]escription: *")
	echo $descr_line | sed -e 's/\ *<!--\ *[Dd]escription\:\ *\(.*\)\ *-->/\1/'
}

function get_default_description() {
	echo "Explore the power and versatility of Lua programming language. From beginner tutorials to advanced techniques. From beginner tutorials to advanced techniques, dive into Lua's elegant syntax and discover its applications in game development, scripting, embedded software and more. Also some useful stuff for web-development."
}

function to_index() {
	if [[ ! -z "$POST_URL" ]]; then
		echo "<a href=\"/\"><em>&larr; Back to the index page</em></a>"
	fi
}

function feedback() {
	if [[ $(is_skipped) = 0 ]]; then
		echo "<h2>Feedback</h2>"
		echo "<p>"
		echo "For feedback, please check the <a href=\"/about.html#contacts\">contacts</a> section."
		echo "Before writing, please specify where you came from and who you are. Sometimes spammers go insane."
		echo "Thank you in advance for your understanding."
		echo "</p>"
	fi
}

# space-separated skip pages in index
SKIP="about.html"
function is_skipped() {
	if [[ "$POST_URL" =~ "$SKIP" ]]; then
		echo 1
	else
		echo 0
	fi
}

DATE_NOW=$(date +"%Y-%m-%d")
BLOG_SUBTITLE="Personal blog about Lua, web, etc."