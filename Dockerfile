FROM ruby:3.1.2-alpine

ARG APPUSER=appuser

RUN apk add \
  bash \
  gettext

WORKDIR /app

COPY Gemfile .
RUN bundle install

RUN adduser -D $APPUSER
USER $APPUSER
