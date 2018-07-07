#!/usr/bin/sh

~/.luarocks/bin/love-release -W 32
~/.luarocks/bin/love-release -W 64
~/.luarocks/bin/love-release -D --author slemonide --desc Realistic rocket simulator with multiplayer --email slemonide@gmail.com -u https://github.com/slemonide/inertia -v 0.1
~/.luarocks/bin/love-release -M --uti public.item
