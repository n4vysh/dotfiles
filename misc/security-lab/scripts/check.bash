#!/bin/bash

set -x

# pods
kubectl get pods \
	-o wide \
	--all-namespaces \
	--ignore-not-found \
	--field-selector=status.phase!=Running,status.phase!=Succeeded
kubectl get pods \
	-o wide \
	--all-namespaces |
	grep CrashLoopBackOff ||
	true

# nodes
kubectl get nodes -o json |
	jq '
		.items[]
		| {
			"name": .metadata.name,
			"condition": .status.conditions
		}
	'
