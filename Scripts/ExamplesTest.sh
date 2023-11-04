#!/usr/bin/sh

cd "$(dirname "$0")" || exit 1
swift sh --clean-cache
try () {
	expected="$1"
	script="$2"
    args="$3"

    if [ "$args" ]; then
        actual="$(echo "$args" | swift sh "$script" 2>/dev/null)"
    else
        actual="$(swift sh "$script" 2>/dev/null)"
    fi

	if [ "$actual" = "$expected" ]; then
		echo "\xE2\x9C\x94 Success $script"
	else
		echo "$expected expected, but got $actual"
		exit 1
	fi
}

try 'testing' '../Examples/echo.swift'

html="<!doctype html>
<html>
<head>
    <title>Example Domain</title>

    <meta charset=\"utf-8\" />
    <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\" />
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />
    <style type=\"text/css\">
    body {
        background-color: #f0f0f2;
        margin: 0;
        padding: 0;
        font-family: -apple-system, system-ui, BlinkMacSystemFont, \"Segoe UI\", \"Open Sans\", \"Helvetica Neue\", Helvetica, Arial, sans-serif;
        
    }
    div {
        width: 600px;
        margin: 5em auto;
        padding: 2em;
        background-color: #fdfdff;
        border-radius: 0.5em;
        box-shadow: 2px 3px 7px 2px rgba(0,0,0,0.02);
    }
    a:link, a:visited {
        color: #38488f;
        text-decoration: none;
    }
    @media (max-width: 700px) {
        div {
            margin: 0 auto;
            width: auto;
        }
    }
    </style>    
</head>

<body>
<div>
    <h1>Example Domain</h1>
    <p>This domain is for use in illustrative examples in documents. You may use this
    domain in literature without prior coordination or asking for permission.</p>
    <p><a href=\"https://www.iana.org/domains/example\">More information...</a></p>
</div>
</body>
</html>"

try "$html" "../Examples/curl.swift"

try "Received input: hh. Test is working. Yay." "../Examples/stdin.swift" "hh"

try "Test Success" "../Examples/cd.swift"
