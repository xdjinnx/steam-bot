run:
	mix run --no-halt

db-create:
	mix ecto.create

db-migrate:
	mix ecto.migrate

format:
	mix format mix.exs "lib/**/*.{ex,exs}" "test/**/*.{ex,exs}"

test:
	mix test

services-run:
	docker run --rm --name pg-docker -e POSTGRES_PASSWORD=docker -d -p 5432:5432 -v ${HOME}/docker/volumes/postgres:/var/lib/postgresql/data postgres

services-stop:
	docker stop pg-docker

rpi-build-deploy:
	docker build -t steam_bot -f rpi.Dockerfile .

rpi-deploy:
	docker-compose up -d

rpi-stop-deploy:
	docker-compose down
