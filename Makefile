SHELL := /bin/bash

.PHONY: \
	build \
	run \
	setup

build: 
	docker-compose \
		build \
		orgproxy \
		orgbot


run: 
	docker-compose \
		up \
		--force-recreate \
		orgbot

