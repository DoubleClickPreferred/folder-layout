#!/bin/sh

fd --version

printf "\n"

printf "fzf $(fzf --version)\n"

printf "\n"

git --version

printf "\n"

java --version | head -1

printf "\n"

printf "haxe $(haxe --version)\n"

printf "\n"

printf "HashLink $(hl --version)\n"

printf "\n"

lua -v

printf "\n"

mvn -v | head -1

printf "\n"

printf "nodeJS $(node -v)\n"

printf "\n"

rg --version | head -1

