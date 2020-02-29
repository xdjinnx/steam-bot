defmodule SteamBot.Application do
  use Application
  alias Alchemy.Client

  defmodule Commands do
    use Alchemy.Cogs

    Cogs.def steam do
      Cogs.say "add\ncompare\ndiscord-users\nbot-users"
    end

    Cogs.def steam(command) do
      case command do
        "add" ->
          Func.add()
          |> Cogs.say
        "compare" ->
          Func.compare(Cogs.member())
          |> Cogs.say
        "discord-users" ->
          Func.discordUsers()
          |> Cogs.say
        "bot-users" ->
          Func.botUsers()
          |> Cogs.say
        _ ->
          Cogs.say("Command not found")
      end
    end

    Cogs.def steam(command, arg1) do
      case command do
        "add" ->
          Func.add(Cogs.member(), arg1)
          |> Cogs.say
        _ ->
          Cogs.say("Command not found")
      end
    end

    Cogs.def steam(command, arg1, arg2) do
      case command do
        "add" ->
          Func.add(Cogs.member(), arg1, arg2)
          |> Cogs.say
        _ ->
          Cogs.say("Command not found")
      end
    end
  end

  def start(_type, _args) do
    run = Client.start("NjgwODk0NTIzODQwNTI4NDA3.XlHRTg.5vGd1X-3o4-3SHK8bvoIQsnSwwQ")
    use Commands
    run
  end
end