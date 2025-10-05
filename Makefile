GIT_STATE ?= $(shell git describe --match=__never_match__ --always --abbrev=13 --dirty)
LOAD_POD ?= ig-load
LOAD_IMAGE ?= gcr.io/claytoncoleman-gke-dev/github.com/smarterclayton/ig-load:main
HF_TOKEN ?= invalid

image:
	[[ -w "$(shell which docker)" ]] || (echo "Cannot invoke 'docker', may require 'sudo'"; exit 1)
	[[ -z "$(shell git ls-files --others --exclude-standard)" ]] || (echo "Cannot build image with untracked files"; exit 1)
	sudo docker build --tag smarterclayton/ig-load:${GIT_STATE} .

up:
	kubectl run ${LOAD_POD} \
		--image=${LOAD_IMAGE} \
		--restart=Always \
		--image-pull-policy=Always \
		--override-type=strategic \
		'--overrides={"spec":{"containers":[{"name": "${LOAD_POD}", "securityContext": {"runAsUser": 0}}]}}' \
		--command \
		-- /bin/bash -c 'trap "" SIGCHLD; sleep infinity'

exec:
	kubectl exec -it ${LOAD_POD} -- /bin/bash

down:
	kubectl delete pod --wait=false --grace-period=1 ${LOAD_POD}

hf_secret:
	kubectl create secret generic hf-secret "--from-literal=HF_TOKEN=${HF_TOKEN}"

sync_builders:
	gcloud builds triggers import --project=claytoncoleman-gke-dev --region=us-central1 --source images/gke_cloud_builders.yaml