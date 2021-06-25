APP_PORT=8080
CONTAINER_PORT=${APP_PORT}
HOST_PORT=${APP_PORT}
VERSION=lastest
DOCKERHUB_ID=gampie
DOCKER_REPOSITORY=python-helloworld
DOCKER_PATH=${DOCKERHUB_ID}/${DOCKER_REPOSITORY}

setup:
	@echo "Logging to hub.docker.com..."
	docker login -u ${DOCKERHUB_ID}
	pip install --upgrade --user pip && \
	pip3 install --upgrade --user pipenv && \
	pipenv --python 3.7
	# Use the virtual env with:
	pipenv shell

install:
	@echo; echo ">>> This should be run inside a virtual env: pipenv shell"
	pipenv install --dev pytest pylint yapf
	pytest --version
	pylint --version
	yapf --version
	pipenv install -r requirements.txt

lint:
	pylint app.py

run-app:
	python3 app.py

test-endpoints:
	curl http://localhost:${APP_PORT}/
	@echo
	curl http://localhost:${APP_PORT}/status
	@echo
	curl http://localhost:${APP_PORT}/metrics

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

argocd:
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

update-argocd-server:
	kubectl apply -f .argocd/argocd-server-nodeport.yml

get-initial-admin-password:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

deploy:
	kubectl apply -f  .argocd/python-helloworld-argocd.yml

clean:
	-docker image rm ${DOCKER_PATH}:${VERSION}
	-pipenv --rm
	@echo "Type exit to leave the pipenv virtual env"
