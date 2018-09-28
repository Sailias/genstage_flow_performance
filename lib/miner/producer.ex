defmodule GenstageFlowTalk.Miner.Producer do
  use GenStage

  @poll_interval_duration 1000

  def start_link do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:producer, 0}
  end

  # When the current queue is empty, send the request
  def handle_demand(demand, 0) do
    Process.send(self(), :mine, [])

    {:noreply, [], demand}
  end

  # The current queue is not empty, so store the new queue
  def handle_demand(demand, queue_length) do
    {:noreply, [], demand + queue_length}
  end

  def handle_info(:mine, queue_length) do
    events = GenstageFlowTalk.Miner.EventGenerator.generate_events(200)

    event_count = Enum.count(events)
    new_queue_length = Enum.max([0, queue_length - event_count])

    # Log for graphing
    GenstageFlowTalk.Progress.incr(:miner_producer, event_count)

    cond do
      # If the queue length is empty, do nothing
      new_queue_length == 0 -> :ok

      # If the events received is empty, queue up a recheck
      event_count == 0 ->
        Process.send_after(self(), :mine, @poll_interval_duration)

      # We have received events but it's not enough, go get more because some consumers are waiting
      true -> Process.send(self(), :mine, [])
    end

    {:noreply, events, new_queue_length}
  end
end