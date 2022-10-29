#!/usr/bin/env bash
# exit on error
set -o errexit

# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile
mix phx.digest
MIX_ENV=prod mix phx.gen.release
MIX_ENV=prod mix release --overwrite