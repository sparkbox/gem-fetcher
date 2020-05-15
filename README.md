# gem-fetcher

This project fetches "gems" from slack into a json data file.

## Install

- Clone or download the repo.

- `bundle install `

## Setup
Create a copy of `.env-sample` and name it `.env`. You will need a Slack API token which you can find in 1Password as "dev-gem-me-bot SLACK API Token".


## Run

- `rackup`

Will serve up on http://localhost:9292


### Generate Data

- `bundle exec rake`
