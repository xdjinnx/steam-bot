# steam-bot

## Working with ecto on server
You should build the rpi.Dockerfile: `sudo docker build -t steam_bot -f rpi.Dockerfile .`
Start the postgres container like this: `sudo docker run --rm --net cat --net-alias postgres --name postgres -e POSTGRES_PASSWORD=docker -d -p 5432:5432 -v ${HOME}/docker/volumes/postgres:/var/lib/postgresql/data postgres`
Then run the container with this command: `sudo docker run -it --network cat --rm steam_bot bash`