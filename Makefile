run:
	mix run --no-halt

db-create:
	mix ecto.create

db-migrate:
	mix ecto.migrate

format:
	mix format mix.exs "lib/**/*.{ex,exs}" "test/**/*.{ex,exs}"

services-run:
	docker-compose up -d

services-stop:
	docker-compose down