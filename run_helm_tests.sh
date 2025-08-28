#!/bin/bash
set -ex
ls -F
cd grafana-observability-stack
helm dependency update
helm install my-obs-stack . --dry-run --debug
