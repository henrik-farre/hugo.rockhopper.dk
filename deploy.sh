#!/bin/bash
# Base on:
# - https://gohugo.io/tutorials/github-pages-blog/
# - https://blog.tohojo.dk/2015/10/automatically-combining-css-files-with-hugo.html
echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

THEME="rockhopper"

rm -rf public/*

STYLESHEET_PATHS="static/css themes/${THEME}/static/css"
JAVASCRIPT_PATHS="static/js"

get_stylesheets()
{
    stylesheets=$(grep 'stylesheets = ' config.toml | sed -e 's/[",]//g' -e 's/stylesheets = \[//' -e 's/\]//')
    for f in $stylesheets; do
        for d in $STYLESHEET_PATHS; do
            if [ -f "$d/$f" ]; then cat "$d/$f"; break; fi
        done
    done
}

get_javascripts()
{
    javascripts=$(grep 'javascripts = ' config.toml | sed -e 's/[",]//g' -e 's/javascripts = \[//' -e 's/\]//')
    for f in $javascripts; do
        for d in $JAVASCRIPT_PATHS; do
            if [ -f "$d/$f" ]; then cat "$d/$f"; break; fi
        done
    done
}

get_javascripts | uglifyjs > static/js/combined.js
get_stylesheets | cssmin > static/css/combined.css

conf=$(mktemp config-XXXX.toml)
sed -e 's/stylesheets = .*/stylesheets = ["combined.css"]/' -e 's/javascripts = .*/javascripts = ["combined.js"]/' config.toml > "$conf"

# Build the project.
hugo --theme="${THEME}" --config="$conf"
rm -f "$conf"

# Remove source css files
find public -name '*.css' -not -name combined.css -delete
# Remove source js files
find public -name '*.js' -not -name combined.js -delete

# Go To Public folder
cd public

# Add changes to git.
git add -A

# Commit changes.
msg="rebuilding site $(date)"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

echo "Resubmitting sitemap to google"
sleep 5

URL="http%3A%2F%2Frockhopper.dk%2Fsitemap.xml"
wget -q "http://google.com/ping?sitemap=${URL}" -O /dev/null

# Come Back
cd ..
