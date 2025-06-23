GIT_STATE ?= $(shell git describe --match=__never_match__ --always --abbrev=13 --dirty)

image:
	[[ -w "$(shell which docker)" ]] || (echo "Cannot invoke 'docker', may require 'sudo'"; exit 1)
	[[ -z "$(shell git ls-files --others --exclude-standard)" ]] || (echo "Cannot build image with untracked files"; exit 1)
	sudo docker build --tag smarterclayton/ig-load:${GIT_STATE} .