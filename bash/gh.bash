#!/bin/bash
GH_BASE_DIR=${GH_BASE_DIR:-$HOME/src}
function gh() {
  URL=$1
  # one argument and a matching url
  if [[ $# -eq 1 ]] && [[ "$1" == https://github.com/*/* ]];
  then
    # cut down url and remove /; remove ".git" if it is at the end
	URL=$(echo ${URL:19} | tr "/" " " | sed "s/.git$//g" )
	user=$(echo $URL | cut -f1 -d" ")
	repo=$(echo $URL | cut -f2 -d" ")
  else
  	if [[ $# -ne 2 ]]; then
      echo "USAGE: gh [user] [repo]"
      echo "   or: gh [url]"
      return
    fi
    user=$1
    repo=$2
  fi
  
  user_path=$GH_BASE_DIR/github.com/$user
  local_path=$user_path/$repo

  if [[ ! -d $local_path ]]; then
    git clone https://github.com/$user/$repo.git $local_path
  fi

  # If git exited uncleanly, clean up the created user directory (if exists)
  # and don't try to `cd` into it.

  if [[ $? -ne 0 ]]; then
    if [[ -d $user_path ]]; then
      rm -d $user_path
    fi
  else
    cd $local_path
  fi
}
