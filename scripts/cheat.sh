#!/usr/bin/env bash

languages=`echo "php lua nvim rust" | tr ' ' '\n'`

selected=`printf "$languages" | fzf`

read -p "query: " query

if printf $languages | grep -qs $selected; then
    tmux neww bash -c "curl cht.sh/$selected/`echo $query | tr ' ' '+'` & while [ : ]; do sleep 1; done"
else
    echo "not found"
fi


