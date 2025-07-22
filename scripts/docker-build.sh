#!/usr/bin/env bash
# syntax=docker/dockerfile:1.4

set -euo pipefail
DOCKER_REPOSITORY="${DOCKER_REPOSITORY:-quay.io/unstructured-io/unstructured-api}"
PIPELINE_PACKAGE=${PIPELINE_PACKAGE:-"general"}
PIPELINE_FAMILY=${PIPELINE_FAMILY:-"general"}
PIP_VERSION="${PIP_VERSION:-25.1.1}"
DOCKER_IMAGE="${DOCKER_IMAGE:-pipeline-family-${PIPELINE_FAMILY}-dev}"
DOCKER_PLATFORM="${DOCKER_PLATFORM:-}"

UNSTRUCTURED_LOCAL_PATH="path/to/be/added/from/pipeline"
DOCKER_BUILD_CMD=(
  docker buildx build --load -f Dockerfile
  --build-context unstructured_src="$UNSTRUCTURED_LOCAL_PATH"
  --build-arg PIP_VERSION="$PIP_VERSION"
  --build-arg BUILDKIT_INLINE_CACHE=1
  --build-arg PIPELINE_PACKAGE="$PIPELINE_PACKAGE"
  --progress plain
  --platform linux/amd64
  --cache-from "$DOCKER_REPOSITORY:latest"
  -t "$DOCKER_IMAGE"
  .
)

# only build for specific platform if DOCKER_PLATFORM is set
if [ -n "${DOCKER_PLATFORM:-}" ]; then
  DOCKER_BUILD_CMD+=("--platform=$DOCKER_PLATFORM")
fi

DOCKER_BUILDKIT=1 "${DOCKER_BUILD_CMD[@]}"
