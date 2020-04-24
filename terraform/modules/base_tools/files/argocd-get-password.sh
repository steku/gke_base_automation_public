#!/bin/bash

# take the json input and extract the CONTEXT variable
eval "$(jq -r '@sh "CONTEXT=\(.context)"')"

CMD="kubectl -n argocd get pods -lapp.kubernetes.io/name=argocd-server -o jsonpath={.items[].metadata.name} --context ${CONTEXT}"

# keep checking until the argocd-server pod is up and get the name
PODNAME=$(${CMD})
until [[ ${PODNAME} != "" ]]
do
  sleep 5
  PODNAME=$(${CMD})
done

# return json with the pod name
jq -n --arg podname ${PODNAME} '{podName: $podname}'

