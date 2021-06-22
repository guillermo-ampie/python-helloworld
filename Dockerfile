FROM python:3-slim AS build-env
LABEL maintainer="Guillermo Ampie"
ADD . /app
# hadolint ignore=DL3013
RUN pip install  --no-cache-dir --upgrade pip && \
    pip install  --no-cache-dir --trusted-host pypi.python.org -r requirements.txt

WORKDIR /app

FROM gcr.io/distroless/python3
COPY --from=build-env /app /app
WORKDIR /app

EXPOSE 8080

CMD [ "python", "app.py" ]
