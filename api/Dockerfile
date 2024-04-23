# syntax=docker/dockerfile:1


FROM python:3.10 as base

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


FROM base as test

ENTRYPOINT [ "pytest" ]
