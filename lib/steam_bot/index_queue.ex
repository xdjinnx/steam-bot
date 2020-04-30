defmodule SteamBot.IndexQueue do
  use GenServer

  def start_link(no_arg) when is_list(no_arg) do
    GenServer.start_link(__MODULE__, no_arg, name: __MODULE__)
  end

  def push(element) do
    GenServer.cast(__MODULE__, {:push, element})
  end

  def pop() do
    case GenServer.call(__MODULE__, :pop) do
      :block ->
        receive do
          {:awaken, data} -> data
        end

      data ->
        data
    end
  end

  @impl true
  def init(_) do
    {:ok, {:queue.new(), []}}
  end

  @impl true
  def handle_call(:pop, from, {{[], []}, waiting}) do
    {:reply, :block, {{[], []}, [from | waiting]}}
  end

  @impl true
  def handle_call(:pop, _, {queue, []}) do
    {{:value, value}, q} = :queue.out(queue)
    {:reply, value, {q, []}}
  end

  @impl true
  def handle_cast({:push, element}, {queue, []}) do
    q = :queue.in(element, queue)
    {:noreply, {q, []}}
  end

  @impl true
  def handle_cast({:push, element}, {_, [next | rest]}) do
    send(elem(next, 0), {:awaken, element})
    {:noreply, {{[], []}, rest}}
  end
end
