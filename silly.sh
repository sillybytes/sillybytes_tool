#!/bin/sh

SB_PATH=$HOME/lab/sillybytes
GH_PAGE=$SB_PATH/sillybytes.github.io

function deploy
{
    cd $GH_PAGE
    git stash -q --keep-index
    git checkout hakyll
    stack build
    stack exec sillybytes rebuild
    git fetch --all
    git checkout -b master --track origin/master
    rsync -a --filter='P _site/' --filter='P _cache/' --filter='P .git/' --filter='P .gitignore' --delete-excluded _site/ .
    git add -A
    git commit -m "Build `date +'%F'`"
    git push origin master:master
    git checkout hakyll
    git branch -D master
    git stash pop -q
}


case "$1" in
    'deploy')
        deploy
        ;;
    *)
        echo "WAT?"
        ;;
esac
