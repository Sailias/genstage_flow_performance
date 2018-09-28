defmodule GenstageFlowTalk.Processor.Consumer do
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    # { :consumer, :ok, subscribe_to: [GenstageFlowTalk.Processor.Producer] }
    { :consumer, :ok, subscribe_to: [{GenstageFlowTalk.Processor.Producer, max_demand: 500}] }
  end

  def handle_events(jobs, _from, state) do
    # Log for graphing
    GenstageFlowTalk.Progress.incr(:processor_consumer, length(jobs))

    # Handle jobs
    Enum.each(jobs, &(&1.()))
    :timer.sleep(300)
    {:noreply, [], state}
  end
end