#!/bin/bash

set -euo pipefail

declare SITE=${1:-site.yml}
declare REPO=${2:-$(git remote get-url origin)}
declare BRANCH="gh-pages"
declare DATE_TIME=`date`

echo "Removing old publish directory"
if [[ -d $DEMO_HOME/gh-publish ]]; then
    rm -rf $DEMO_HOME/gh-publish 
fi

echo "Removing antora cache directory"
if [[ -d $DEMO_HOME/.cache ]]; then
    rm -rf $DEMO_HOME/.cache 
fi

echo "Cloning repo"
git clone -b ${BRANCH} ${REPO} $DEMO_HOME/gh-publish

echo "Pulling images"
cd $DEMO_HOME/gh-publish/
git pull
cd $DEMO_HOME

echo "Generating the site documentation from ${SITE}"

antora generate --stacktrace $DEMO_HOME/${SITE} --to-dir $DEMO_HOME/gh-publish

echo "Pushing site to ${BRANCH} branch of ${REPO}"
cd $DEMO_HOME/gh-publish
git add --all .
git commit -m "Automated Publish ${DATE_TIME}" 
git push origin ${BRANCH}
echo "Site published successfully!"