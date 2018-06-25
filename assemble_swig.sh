#!/bin/bash

if [ -z "$1" ]; then
	echo "Syntax: $0 <install path>"
	exit 1
fi

pushd `dirname "$0"` || exit 1

HASH=`git log -1 --pretty=format:"%H"`
[ -n "$HASH" ] || exit 1

if [ -f "$1/hash" ]; then
	if [ -f "$1/bin/swig" ]; then 
		grep "$HASH" "$1/hash" 1>/dev/null && exit 0
	fi
	rm "$1/hash"
fi

./autogen.sh || exit 1
./configure --prefix "$1" || exit 1
make || exit 1
make install || exit 1
echo "$HASH" > "$1/hash"
git clean -dfx
popd

