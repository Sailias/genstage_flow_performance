defmodule GenstageFlowTalk.Miner.Consumer do
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    { :consumer, :ok, subscribe_to: [{GenstageFlowTalk.Miner.Producer, max_demand: 50}] }
  end

  def handle_events(jobs, _from, state) do
    # Log for graphing
    GenstageFlowTalk.Progress.incr(:miner_consumer, length(jobs))

    # Handle jobs
    Enum.each(jobs, &(&1.()))
    :timer.sleep(500)
    {:noreply, [], state}
  end
end