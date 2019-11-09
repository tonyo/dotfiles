#!/bin/bash
set -eux

NUM=$1
BRANCH_NAME="pr-number-$NUM"

git branch -M $BRANCH_NAME ${BRANCH_NAME}-old || true
git fetch origin pull/${NUM}/head:$BRANCH_NAME
git checkout $BRANCH_NAME
