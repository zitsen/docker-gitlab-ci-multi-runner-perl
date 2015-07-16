# Docker image with gitlab-ci-multi-runner to run builds with perl

Docker image with gitlab-ci-multi-runner, which can run perl builds. It uses [perlbrew](http://perlbrew.pl/) to manage perl versions.

## How to use

Example of [Docker Compose](https://docs.docker.com/compose/) file (`docker-compose.yml`)

```
vrunner:
  image: busybox
    volumes:
        - /home/gitlab_ci_multi_runner/data

runner:
    image: zitsen/gitlab-ci-multi-runner-perl:latest
    volumes_from:
        - vrunner
    environment:
        - CI_SERVER_URL=https://gitlabci.example.com
        - RUNNER_TOKEN=YOUR_TOKEN_FROM_GITLABCI
    restart: always
```

Replace `CI_SERVER_URL` and `RUNNER_TOKEN`.

Run it

```
docker-compose up -d
```

Or using docker command line

```
docker run -d --env "CI_SERVER_URL=https://gitlabci.example.com" \
              --env "RUNNER_TOKEN=YOUR_TOKEN_FROM_GITLABCI" \
              --restart="always" \
              --name=gitlab_ci_perl_runner \
              zitsen/gitlab-ci-multi-runner-perl:latest
```

In your project add `.gitlab-ci.yml`

```
before_script:
  - perlbrew exec dzil authordeps --missing | xargs perlbrew exec cpanm -M "https://cpan.metacpan.org"

build:
  script:
    - perlbrew exec dzil test
  tags:
    - perl
```

`before_script` will install required ruby version specified with `RBENV_VERSION`, install `bundle` and `gems` from your `Gemfile`.

`build` will invoke ruby and ask ruby version.

## More information

* Read about [gitlab-ci-multi-runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/) to learn how integration works with GitLab CI.
* This repo is something like [docker-gitlab-ci-multi-runner-ruby](https://github.com/outcoldman/docker-gitlab-ci-multi-runner-ruby), which is the runner for ruby.
* This image is based on [docker-gitlab-ci-multi-runner](https://github.com/sameersbn/docker-gitlab-ci-multi-runner), which handles registration and startup.
