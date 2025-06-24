GIT_STATE ?= $(shell git describe --match=__never_match__ --always --abbrev=13 --dirty)
LOAD_POD ?= ig-load

image:
	[[ -w "$(shell which docker)" ]] || (echo "Cannot invoke 'docker', may require 'sudo'"; exit 1)
	[[ -z "$(shell git ls-files --others --exclude-standard)" ]] || (echo "Cannot build image with untracked files"; exit 1)
	sudo docker build --tag smarterclayton/ig-load:${GIT_STATE} .

up:
	kubectl run ${LOAD_POD} \
		--image=gcr.io/claytoncoleman-gke-dev/github.com/smarterclayton/ig-load:38394b84f6bc348bedc2f14d3cb19672e1577fb9 \
		--restart=Always \
		-- sleep infinity

exec:
	kubectl exec -it ${LOAD_POD} -- /bin/bash

down:
	kubectl delete pod --wait=false --grace-period=1 ${LOAD_POD}