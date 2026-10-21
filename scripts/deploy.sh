#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: ./scripts/deploy.sh <jenkins-build-number>"
  exit 1
fi

BUILD_NUMBER="$1"
IMAGE="dineshk26/devops-platform:${BUILD_NUMBER}"
MANIFEST="kubernetes/deployment.yaml"

echo "Checking Kubernetes context..."
CONTEXT="$(kubectl config current-context)"
echo "Current context: ${CONTEXT}"

if [[ "$CONTEXT" != "kind-"* ]]; then
  echo "ERROR: Expected a kind context. Refusing to deploy."
  exit 1
fi

echo "Updating deployment image to ${IMAGE}..."
kubectl set image deployment/devops-platform \
  devops-platform="${IMAGE}"

echo "Waiting for rollout..."
kubectl rollout status deployment/devops-platform --timeout=120s

echo "Checking pods..."
kubectl get pods -l app=devops-platform

echo "Deployment completed for ${IMAGE}"
