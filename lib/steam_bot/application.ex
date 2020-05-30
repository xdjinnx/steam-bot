defmodule SteamBot.Application do
  use Application
  alias Alchemy.Client

  defmodule Commands do
    use Alchemy.Cogs

    Cogs.def steam do
      SteamBot.Handler.Help.get_response() |> Cogs.say()
    end

    Cogs.def steam(command) do
      case command do
        "add" ->
          SteamBot.Handler.Add.ask()
          |> Cogs.say()

        "compare" ->
          SteamBot.Handler.Compare.ask(Cogs.member(), Cogs.guild_id())
          |> SteamBot.Handler.Compare.interpret_response()
          |> Cogs.say()

        "discord-users" ->
          SteamBot.Handler.DiscordUsers.ask(Cogs.guild_id())
          |> SteamBot.Handler.DiscordUsers.interpret_response()
          |> Cogs.say()

        "bot-users" ->
          SteamBot.Handler.BotUsers.ask()
          |> SteamBot.Handler.BotUsers.interpret_response()
          |> Cogs.say()

        "index" ->
          SteamBot.Handler.Index.ask(Cogs.member())
          |> SteamBot.Handler.Index.interpret_response()
          |> Cogs.say()

        _ ->
          Cogs.say("Command not found")
      end
    end

    Cogs.def steam(command, arg1) do
      case command do
        "add" ->
          SteamBot.Handler.Add.ask(Cogs.member(), arg1)
          |> SteamBot.Handler.Add.interpret_response()
          |> Cogs.say()

        "index" ->
          SteamBot.Handler.Index.ask(arg1)
          |> SteamBot.Handler.Index.interpret_response()
          |> Cogs.say()

        "search" ->
          SteamBot.Handler.Search.ask(arg1)
          |> SteamBot.Handler.Search.interpret_response()
          |> Cogs.say()
        _ ->
          Cogs.say("Command not found")
      end
    end

    Cogs.def steam(command, arg1, arg2) do
      case command do
        "add" ->
          SteamBot.Handler.Add.ask(Cogs.guild_id(), arg1, arg2)
          |> SteamBot.Handler.Add.interpret_response()
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
      SteamBot.GameIndex.IndexQueue,
      SteamBot.GameIndex.Indexer
    ]

    opts = [strategy: :one_for_one, name: SteamBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
