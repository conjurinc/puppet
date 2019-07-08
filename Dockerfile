FROM ruby:2.4
MAINTAINER Conjur Inc

RUN mkdir /conjur
WORKDIR /conjur

COPY Gemfile /conjur/Gemfile
COPY Gemfile.lock /conjur/Gemfile.lock

ARG PUPPET_VERSION
RUN env PUPPET_VERSION=$PUPPET_VERSION bundle

COPY . /conjur
