FROM ruby:3.1.2-alpine

ARG APPUSER=appuser

RUN apk add \
  bash \
  gettext

WORKDIR /app

RUN adduser -D $APPUSER
USER $APPUSER
