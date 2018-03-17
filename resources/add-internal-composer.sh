#!/bin/bash -e

cd

echo "whoami:"
whoami

echo "pwd:"
pwd

mkdir -p ~/.composer

cat > ~/.composer/config.json << EOM
{
    "config": {
        "secure-http": false
    },
    "repositories": [
        {
            "type": "composer",
            "url": "http://composer"
        }
    ]
}
EOM

cat ~/.composer/config.json