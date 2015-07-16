#!/bin/bash
docker build -t=$USER/gitlab-ci-multi-runner-perl -rm=true $@ .
