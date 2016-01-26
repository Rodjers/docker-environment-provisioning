#!/bin/bash

ID=`cat id` 
docker-machine ls -q | grep "$ID" | xargs docker-machine rm -f
