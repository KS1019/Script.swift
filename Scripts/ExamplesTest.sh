#!/usr/bin/sh

cd "$(dirname "$0")" || exit 1
swift sh --clean-cache
try () {
	expected="$1"
	script="$2"
	actual=$(swift sh "$script")

	if [ "$actual" = "$expected" ]; then
		echo "\xE2\x9C\x94 Success $script => $actual"
	else
		echo "$expected expected, but got $actual"
		exit 1
	fi
}

try 'testing' '../Examples/echo.swift'