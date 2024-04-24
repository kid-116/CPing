# syntax=docker/dockerfile:1


FROM --platform=linux/amd64 python:3.10 as base

RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get -y update \
    && apt-get -y install google-chrome-stable

COPY . /usr/src/app
WORKDIR /usr/src/app

RUN --mount=type=cache,target=/root/.cache \
    pip install -r ./requirements.txt


FROM base as dev

ENTRYPOINT [ "flask", "run", "--debug", "-h", "0.0.0.0" ]

ENV GCLOUD_PROJECT=cping-7e228


FROM base as test

ENTRYPOINT [ "pytest" ]


FROM base as prod

RUN apt-get -y install nginx

COPY nginx.conf /etc/nginx

RUN chmod +x ./start.sh
ENTRYPOINT [ "./start.sh" ]
