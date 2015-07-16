FROM sameersbn/gitlab-ci-multi-runner:latest
MAINTAINER Huo Linhe <huolinhe@berrygenomics.com>

ADD data/sources.list /etc/apt/sources.list
RUN apt-get update

# install build essentials
RUN apt-get install -y --no-install-recommends \
        git-core \
        curl \
		autoconf \
		automake \
		bzip2 \
		file \
		g++ \
		gcc \
		imagemagick \
		libbz2-dev \
		libc6-dev \
		libcurl4-openssl-dev \
		libevent-dev \
		libffi-dev \
		libglib2.0-dev \
		libjpeg-dev \
		liblzma-dev \
		libmagickcore-dev \
		libmagickwand-dev \
		libmysqlclient-dev \
		libncurses-dev \
		libpq-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		libtool \
		libxml2-dev \
		libxslt-dev \
		libyaml-dev \
		make \
		patch \
		xz-utils \
		zlib1g-dev

# install R
RUN apt-get install -y --no-install-recommends r-base

# prepare perlbrew path
RUN mkdir -p /usr/local/perlbrew
ENV PERLBREW_ROOT /usr/local/perlbrew

# install perlbrew
RUN curl -L http://install.perlbrew.pl | bash

ENV PATH /usr/local/perlbrew/bin:$PATH
ENV PERLBREW_PATH /usr/local/perlbrew/bin
RUN cp /usr/local/perlbrew/etc/bashrc /etc/profile.d/perlbrew.sh

RUN echo source /usr/local/perlbrew/etc/bashrc | bash
RUN perlbrew install -j4 -nv perl-5.20.2 perl.5.10.1
RUN perlbrew install-cpanm
RUN perlbrew exec cpanm -nq Moo Moose
RUN perlbrew exec cpanm -nq Dist::Zilla

RUN locale-gen en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

ENV RUNNER_DESCRIPTION=perl
ENV RUNNER_DESCRIPTION=shell
ENV RUNNER_TAG_LIST=perl
ENV RUNNER_LIMIT=1

ENV RUNNER_TOKEN=
ENV CI_SERVER_URL=
