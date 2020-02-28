const Discord = require('discord.js');
const client = new Discord.Client();
var logger = require('winston');

const SteamAPI = require("steamapi");
const steam = new SteamAPI("8C1444D72335D5A78A543DBB1CDE6A91");

var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database('./db.sql');

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
        add(channel, author, args[1], args[2]);
        break;
      case 'bot-users':
        displayBotUsers(channel);
        break;
      case 'discord-users':
        displayDiscordUsers(channel);
        break;
      default:
        channel.send("Sorry can't understand: " + "'" + cmd +"'");
    }
  }
});

client.login("NjgwODk0NTIzODQwNTI4NDA3.XlHRTg.5vGd1X-3o4-3SHK8bvoIQsnSwwQ").then();

function add(channel, author, steamID, discordUserID) {
  var userId = discordUserID || author.id;
  var username = author.username;

  channel.members.array().forEach( user => {
    if (user.user.id === userId) {
      username = user.user.username;
    }
  });

  logger.info(userId + " : " + steamID);
  steam.getUserSummary(steamID).then( summery => {
    db.serialize(function() {
      var stmt = db.prepare("INSERT INTO User (id, username, steam_id, steam_name) VALUES (?, ?, ?, ?)");
      stmt.run(
        userId,
        username,
        steamID,
        summery.nickname
      );
      stmt.finalize();
    });

    permissionCheck(steamID).then( error => {
      var problem = "";
      if (error) {
        problem = "The steam user seems to have permission issues!";
      }

      channel.send("Thank you " + author.username + ", I have added: " + summery.nickname + "! " + problem);
    })
  }, error => {
    channel.send("Steam ID provided is invalid");
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

  //var stmt = db.prepare("SELECT * FROM User WHERE id IN (?)");
  //stmt.each("");

  var promises = [];
  var missingSteamID = "";
  voiceChannel.members.array().forEach( user => {
    if (users[user.user.id]) {
      promises.push(steam.getUserOwnedGames(users[user.user.id].steamID).then( games => {
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

function displayBotUsers(channel) {
  var message ="";

  db.each("SELECT username, steam_id FROM User", function(err, row) {
    message += row.username + ":" + row.steam_id + ", "
  }, function() {
    channel.send(message)
  });
}

function displayDiscordUsers(channel) {
  var message = "";

  channel.members.array().forEach( user => {
    message += user.user.username + ":" + user.user.id + ", ";
  });

  channel.send(message)
}

function permissionCheck(steamID) {
  return steam.getUserOwnedGames(steamID).then( games => {
    return null
  }, error => {
    logger.info(error);
    return error
  });
}