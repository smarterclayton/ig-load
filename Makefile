GIT_STATE ?= $(shell git describe --match=__never_match__ --always --abbrev=13 --dirty)
LOAD_POD ?= ig-load
LOAD_IMAGE ?= gcr.io/claytoncoleman-gke-dev/github.com/smarterclayton/ig-load:main

image:
	[[ -w "$(shell which docker)" ]] || (echo "Cannot invoke 'docker', may require 'sudo'"; exit 1)
	[[ -z "$(shell git ls-files --others --exclude-standard)" ]] || (echo "Cannot build image with untracked files"; exit 1)
	sudo docker build --tag smarterclayton/ig-load:${GIT_STATE} .

up:
	kubectl run ${LOAD_POD} \
		--image=${LOAD_IMAGE} \
		--restart=Always \
		--image-pull-policy=Always \
		--command \
		-- /bin/bash -c 'sleep infinity'

exec:
	kubectl exec -it ${LOAD_POD} -- /bin/bash

down:
	kubectl delete pod --wait=false --grace-period=1 ${LOAD_POD}

