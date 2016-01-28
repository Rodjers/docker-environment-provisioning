#!/bin/bash
log() {
	echo "=== $1"
}

eval $(cat env);

docker-compose scale interlock=1 gitlebook=4
