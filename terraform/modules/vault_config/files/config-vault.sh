#!/bin/bash

# get the CONTEXT and KES_NAMESPACE from the input json
eval "$(jq -r '@sh "CONTEXT=\(.context) KES_NAMESPACE=\(.kes_namespace)"')"

# get the token secret and token from k8s
KES_TOKEN_SECRET=$(kubectl get sa -n ${KES_NAMESPACE} kes-kubernetes-external-secrets -o jsonpath='{.secrets[].name}' --context ${CONTEXT})
KUBE_TOKEN=$(kubectl -n ${KES_NAMESPACE} get secret ${KES_TOKEN_SECRET} -o jsonpath={.data.token} --context ${CONTEXT})

# return a json string with the token
jq -n --arg kube_token "${KUBE_TOKEN}" '{kube_token: $kube_token}'
