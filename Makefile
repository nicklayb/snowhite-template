ASSETS_FOLDER=assets

DOCKER_REGISTRY=hal:5000
DOCKER_TAG=latest
DOCKER_IMAGE=snowhite:$(DOCKER_TAG)
DOCKER_REMOTE_IMAGE=$(DOCKER_REGISTRY)/$(DOCKER_IMAGE)

.PHONY: dev
dev:
	iex -S mix phx.server

.PHONY: deps
deps: mix-deps nodejs-deps

.PHONY: mix-deps
mix-deps:
	mix deps.get

.PHONY: nodejs-deps
nodejs-deps:
	npm install --prefix $(ASSETS_FOLDER)

.PHONY: secret
secret:
	mix phx.gen.secret 64

.PHONY: test
test:
	mix test

.PHONY: setup
setup: deps copy-template

.PHONY: setup
setup: deps copy-template

.PHONY: copy-template
copy-template:
	mix snowhite.copy_template

.PHONY: docker-build
docker-build:
	docker build -f ./dockerfiles/Dockerfile -t $(DOCKER_IMAGE) .

.PHONY: docker-tag
docker-tag:
	docker tag $(DOCKER_IMAGE) $(DOCKER_REMOTE_IMAGE)

.PHONY: docker-push
docker-push:
	docker push $(DOCKER_REMOTE_IMAGE)

.PHONY: release-docker
release-docker: docker-build docker-tag docker-push

