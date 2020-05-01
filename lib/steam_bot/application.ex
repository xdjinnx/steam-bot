defmodule SteamBot.Application do
  use Application
  alias Alchemy.Client

  defmodule Commands do
    use Alchemy.Cogs

    Cogs.def steam do
      SteamBot.Handler.Help.help() |> Cogs.say()
    end

    Cogs.def steam(command) do
      case command do
        "add" ->
          SteamBot.Handler.Add.add() |> Cogs.say()

        "compare" ->
          SteamBot.Handler.Compare.compare(Cogs.member(), Cogs.guild_id()) |> Cogs.say()

        "discord-users" ->
          SteamBot.Handler.DiscordUsers.discord_users(Cogs.guild_id()) |> Cogs.say()

        "bot-users" ->
          SteamBot.Handler.BotUsers.bot_users() |> Cogs.say()

        "index" ->
          SteamBot.Handler.Index.index(Cogs.member()) |> Cogs.say()

        _ ->
          Cogs.say("Command not found")
      end
    end

    Cogs.def steam(command, arg1) do
      case command do
        "add" ->
          SteamBot.Handler.Add.add(Cogs.member(), arg1)
          |> Cogs.say()

        "index" ->
          SteamBot.Handler.Index.index(arg1)
          |> Cogs.say()

        _ ->
          Cogs.say("Command not found")
      end
    end

    Cogs.def steam(command, arg1, arg2) do
      case command do
        "add" ->
          SteamBot.Handler.Add.add(Cogs.guild_id(), arg1, arg2)
          |> Cogs.say()

        _ ->
          Cogs.say("Command not found")
      end
    end
  end

  def start(_type, _args) do
    Client.start(Application.get_env(:steam_bot, :discord_key))
    use Commands

    Alchemy.Cogs.set_prefix(Application.get_env(:steam_bot, :call_prefix))

    children = [
      SteamBot.Repo,
      SteamBot.IndexQueue,
      SteamBot.Indexer
    ]

    opts = [strategy: :one_for_one, name: SteamBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
