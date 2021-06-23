APP_PORT=8080
CONTAINER_PORT=${APP_PORT}
HOST_PORT=${APP_PORT}
VERSION=lastest
DOCKERHUB_ID=gampie
DOCKER_REPOSITORY=python-helloworld
DOCKER_PATH=${DOCKERHUB_ID}/${DOCKER_REPOSITORY}

setup:
	docker login -i ${DOCKERHUB_ID}

run-app:
	go run main.go

test-app:
	curl http://localhost:${APP_PORT}/
	@echo

build-docker:
	docker build --tag ${DOCKER_PATH}:${VERSION} .
	@echo
	docker image ls ${DOCKER_PATH}
	@echo

run-docker: build-docker
	docker run -t --rm -p ${HOST_PORT}:${CONTAINER_PORT} ${DOCKER_PATH}:${VERSION}

push-docker: build-docker
	# docker tag ${DOCKER_REPOSITORY}:${VERSION} ${DOCKER_PATH}:${VERSION}
	docker push ${DOCKER_PATH}:${VERSION}

clean:
	docker image rm ${DOCKER_PATH}:${VERSION}
	