defmodule SteamBot.Application do
  use Application
  alias Alchemy.Client

  defmodule Commands do
    use Alchemy.Cogs

    Cogs.def steam do
      Func.help() |> Cogs.say()
    end

    Cogs.def steam(command) do
      case command do
        "add" ->
          Func.add() |> Cogs.say()

        "compare" ->
          Func.compare(Cogs.member(), Cogs.guild_id()) |> Cogs.say()

        "discord-users" ->
          Func.discord_users(Cogs.guild_id()) |> Cogs.say()

        "bot-users" ->
          Func.bot_users() |> Cogs.say()

        "index" ->
          Func.index(Cogs.member()) |> Cogs.say()

        _ ->
          Cogs.say("Command not found")
      end
    end

    Cogs.def steam(command, arg1) do
      case command do
        "add" ->
          Func.add(Cogs.member(), arg1)
          |> Cogs.say()

        _ ->
          Cogs.say("Command not found")
      end
    end

    Cogs.def steam(command, arg1, arg2) do
      case command do
        "add" ->
          Func.add(Cogs.guild_id(), arg1, arg2)
          |> Cogs.say()

        _ ->
          Cogs.say("Command not found")
      end
    end
  end

  def start(_type, _args) do
    run = Client.start(Application.get_env(:steam_bot, :discord_key))
    use Commands
    run

    import Supervisor.Spec, warn: false

    children = [
      Repo
    ]

    opts = [strategy: :one_for_one, name: SteamBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
