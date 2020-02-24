const Discord = require('discord.js');
const client = new Discord.Client();
var logger = require('winston');

const SteamAPI = require("steamapi");
const steam = new SteamAPI("8C1444D72335D5A78A543DBB1CDE6A91");

// Configure logger settings
logger.remove(logger.transports.Console);
logger.add(new logger.transports.Console, {
  colorize: true
});
logger.level = 'debug';
// Initialize Discord Bot
client.on('ready', () => {
  logger.info('Connected');
  logger.info('Logged in as: ');
});
client.on('message', event => {
  logger.info(message)

  var channel = event.channel;
  var author = event.author;
  var message = event.content;

  // Our bot needs to know if it will execute a command
  // It will listen for messages that will start with `!`
  if (message.substring(0, 6) == '!steam') {
    var args = message.substring(7).split(' ');
    logger.info(args);

    var cmd = args[0];

    switch(cmd) {
      case 'compare':
        compare(channel, author);
        break;
      case 'add':
        add(channel, author, args[1]);
        break;
        // Just add any case commands if you want to..
      default:
        channel.send("Sorry can't understand: " + "'" + cmd +"'");
    }
  }
});

client.login("NjgwODk0NTIzODQwNTI4NDA3.XlHRTg.5vGd1X-3o4-3SHK8bvoIQsnSwwQ").then();

var users = {};

function add(channel, author, steamID) {
  logger.info(author.id + " : " + steamID);
  steam.getUserSummary(steamID).then( summery => {
    users[author.id] = steamID;

    permissionCheck(steamID).then( error => {
      var problem = "";
      if (error) {
        problem = "But the user seems to have permission issues!";
      }

      channel.send("Thank you " + author.username + ", I have added: " + summery.nickname + "! " + problem);
    })
  });
}

function compare(messageChannel, author) {
  var voiceChannel = null
  client.channels.cache.array().forEach( channel => {
    if (channel.type !== "voice") {
      return
    }

    channel.members.array().forEach( user => {
      if (user.user.id === author.id) {
        voiceChannel = channel
      }
    });
  });

  if (!voiceChannel) {
    messageChannel.send("Sorry you are not in a voice channel");
    return
  }

  var promises = [];
  var missingSteamID = "";
  voiceChannel.members.array().forEach( user => {
    if (users[user.user.id]) {
      promises.push(steam.getUserOwnedGames(users[user.user.id]).then( games => {
        return {games: games, user: user.user.id}
      }));
    } else {
      missingSteamID += user.user.username + ", ";
    }
  });

  if (missingSteamID) {
    messageChannel.send("Sorry missing steam id for: " + missingSteamID);
  }

  Promise.all(
    promises
  ).then( responses => {
    var games = [];
    responses[0].games.forEach( game => {
      games.push({id: game.appID, name: game.name, owners: []})
    });

    responses.forEach( response => {
      var tempGames = [];
      response.games.forEach( game => {
        games.forEach( gameInList => {
          if (gameInList.id === game.appID) {
            gameInList.owners.push(response.user);
            tempGames.push({id: game.appID, name: game.name, owners: gameInList.owners});
          }
        })
      });

      games = tempGames;
    });

    if (games.length < 1) {
      return
    }

    var ownersString = "";
    games[0].owners.forEach( owner => {
      ownersString += "<@" + owner + ">, "
    });

    var gamesString = "";
    games.forEach( game => {
      gamesString += game.name + ", "
    });

    messageChannel.send(ownersString + " have " + games.length + " games in common: " + gamesString);
  });
}

function permissionCheck(steamID) {
  return steam.getUserOwnedGames(steamID).then( games => {
    return null
  }, error => {
    logger.info(error);
    return error
  });
}