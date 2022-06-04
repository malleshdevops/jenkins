#!/bin/bash

CDIR=$(cd `dirname "$0"` && pwd)
cd "$CDIR"
set -e
function help()
{
  echo '''
    usage: bash deploy.sh <Namespace> <IMAGE_TAG>
	'''
}

NAMESPACE=$1
CHARTNAME=$1
IMAGE_TAG=$2

VALUE_FILE=./mychart/values-${NAMESPACE}.yaml

function deploy()
{
 case ${NAMESPACE} in
       dev-httpd|test-httpd|prod-httpd)
	       helm upgrade --install --values ${VALUE_FILE} $CHARTNAME ./mychart \
		   --namespace ${NAMESPACE} --set image.tag=${IMAGE_TAG}
		;;
 esac
 }
 
if [ ! $# == 2 ]
then
  help
  exit 0
else
   deploy "$@"
   deployName=${NAMESPACE}
fi
