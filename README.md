# Sidekiq Monitor Github OAuth

[![Dependency Status](https://gemnasium.com/badges/github.com/TangRufus/sidekiq-monitor-github-oauth.svg)](https://gemnasium.com/github.com/TangRufus/sidekiq-monitor-github-oauth)
[![Code Climate](https://codeclimate.com/github/TangRufus/sidekiq-monitor-github-oauth/badges/gpa.svg)](https://codeclimate.com/github/TangRufus/sidekiq-monitor-github-oauth)
[![License-GPLv2-blue](https://img.shields.io/badge/License-GPLv2-blue.svg)](https://github.com/TangRufus/sidekiq-monitor-github-oauth/blob/master/LICENSE)


A tiny Github-OAuth protected Sinatra app to display the current state of a Sidekiq installation.

Originally forked from [tbalthazar/sidekiq-web-ui](https://github.com/tbalthazar/sidekiq-web-ui). This repo use [Github OAuth](https://developer.github.com/v3/oauth/) instead of HTTP basic auth.


## Usage

This [standalone Sinatra app](https://github.com/mperham/sidekiq/wiki/Monitoring#standalone) helps monitoring a [Sidekiq](http://sidekiq.org/) installation running as a separate app.

Made to monitor a Sidekiq installation running on [Heroku](https://heroku.com), but it should be usable elsewhere too.


## Prerequisite

Register your application on [Github](https://github.com/settings/developers).

Default authorization callback URL: `<http://example.com>/auth/github/callback`

You will need the `Client ID` and `Client Secret`.


## Installation

```shell
git clone https://github.com/TangRufus/sidekiq-monitor-github-oauth.git
cd sidekiq-monitor-github-oauth
bundle install
cp .env.example .env
```

## Deployment

If you are using [Heroku](https://heroku.com), just click the deploy button and configure the envirment variables.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/TangRufus/sidekiq-monitor-github-oauth)


## Setting environment variables:

Edit the `.env` file values:

- `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET`

	Get these values from your [Github application settings page](https://github.com/settings/developers)


- `GITHUB_ORG`

	Set this to your Github organization name to provide access to organization members only.


- `REDIS_URL`

	URL to redis server


- `LOGOUT_REDIRECT_URL`

	Where to go after logout?


- `WARDEN_GITHUB_VERIFIER_SECRET`

	A very long random string

	`$ openssl rand -base64 48` and `$ rails secret` are your friends.


## To start the server:

`$ heroku local web` or `$ foreman start`

