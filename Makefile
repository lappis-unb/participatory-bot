include bot/.env
export $(shell sed 's/=.*//' bot/.env)

current_dir := $(shell pwd)
user := $(shell whoami)

ENDPOINTS = endpoints.yml
CREDENTIALS = credentials.yml

# CLEAR PROJECT
clean:
	make down
	cd bot/ && sudo make clean

down:
	docker compose down

# RUN
init:
	make build
	make train
	make webchat

logs:
	docker compose logs \
		-f

build:
	export $(grep -v '^#' env/bot.env | xargs)
	docker compose build \
		--no-cache bot

shell:
	docker compose run \
		--rm \
		--service-ports \
		bot \
		make shell ENDPOINTS=$(ENDPOINTS)

api:
	docker compose run \
		--rm \
		--service-ports \
		bot \
		make api ENDPOINTS=$(ENDPOINTS) CREDENTIALS=$(CREDENTIALS)

actions:
	docker compose run \
		--rm \
		--service-ports \
		bot \
		make actions

webchat:
	echo "Executando Bot com Webchat."
	docker compose run \
		-d \
		--service-ports \
		bot \
		make webchat ENDPOINTS=$(ENDPOINTS) CREDENTIALS=$(CREDENTIALS)
	docker compose up \
		-d \
		webchat
	echo "Acesse o WEBCHAT em: http://localhost:5000"

telegram:
	docker compose run \
		-d \
		--rm \
		--service-ports \
		bot-telegram \
		make telegram ENDPOINTS=$(ENDPOINTS) CREDENTIALS=$(CREDENTIALS)

# DEVELOPMENT
train:
	docker compose run \
		--rm  \
		bot \
		make train

validate:
	docker compose run \
		--rm bot \
		make validate

test:
	docker compose run \
		--rm bot \
		make test

test-nlu:
	docker compose run \
		--rm \
		bot \
		make test-nlu

test-core:
	docker compose run \
		--rm \
		bot \
		make test-core

