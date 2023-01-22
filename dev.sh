#!/bin/bash

docker build -t phprio .
docker run -p 8000:8000 -v $(pwd)/app:/home phprio
