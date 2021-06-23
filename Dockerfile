# Reference: https://github.com/GoogleContainerTools/distroless/blob/main/examples/python3-requirements/Dockerfile
FROM debian:buster-slim AS build
RUN apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends python3 python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    python3 -m venv /venv && \
    /venv/bin/pip install  --no-cache-dir --upgrade pip

FROM build AS build-venv
COPY ./requirements.txt /requirements.txt
RUN  /venv/bin/pip install  --no-cache-dir -r /requirements.txt

FROM gcr.io/distroless/python3
COPY --from=build-venv /venv /venv
COPY . /app
WORKDIR /app

EXPOSE 8080

ENTRYPOINT [ "/venv/bin/python3", "app.py" ]
