# steam-bot
SteamBot is a Discord bot that you can use when you want to compare steam games between all current voice chat attendees.



### Setup
You need to add discord key and steam key in the config exs.

The bot is designed to be deployed with docker compose.
You can deploy it with the Make targets.

You have to invite the bot to your server.

### Nice to know

#### Running on Raspberry pi
I built this bot to be run on a raspberry pi and for private use.

#### Working with ecto on server
You should build the rpi.Dockerfile: `sudo docker build -t steam_bot -f rpi.Dockerfile .`
Start the postgres container like this: `sudo docker run --rm --net cat --net-alias postgres --name postgres -e POSTGRES_PASSWORD=docker -d -p 5432:5432 -v ${HOME}/docker/volumes/postgres:/var/lib/postgresql/data postgres`
Then run the container with this command: `sudo docker run -it --network cat --rm steam_bot bash`