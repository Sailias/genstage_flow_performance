defmodule GenstageFlowTalk.Processor.Producer do
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok), do: {:producer, {:queue.new(), 0}}

  def enqueue_jobs(jobs) do
    # Log for graphing
    GenstageFlowTalk.Progress.incr(:processor_producer, length(jobs))

    GenStage.call(__MODULE__, {:enqueue_jobs, jobs})
  end

  def handle_call({:enqueue_jobs, jobs}, _from, {queue, pending_demand}) do
    # Take all the jobs and add them to the queue
    queue = Enum.reduce(jobs, queue, &:queue.in(&1, &2))

    # After we increased our queue, let's take our jobs based on our pending demand
    # and process the backlog
    {reversed_jobs, state} = take_jobs(queue, pending_demand, [])
    {:reply, :ok, Enum.reverse(reversed_jobs), state}
  end

  def handle_demand(demand, {queue, pending_demand}) do
    {reversed_jobs, state} = take_jobs(queue, pending_demand + demand, [])
    {:noreply, Enum.reverse(reversed_jobs), state}
  end

  # If there isn't any demand, just return the jobs and the queue with 0 pending demand
  defp take_jobs(queue, 0, jobs), do: {jobs, {queue, 0}}

  # If there is pending_demand, process the queue
  defp take_jobs(queue, n, jobs) when n > 0 do

    # Take an item out of the queue one at a time until we take the demand out of the queue
    case :queue.out(queue) do
      # If the queue is empty, store the queue and the demand
      {:empty, ^queue} -> {jobs, {queue, n}}

      # If the queue is not empty, take the single job out of the queue
      # prepend it to an array, and keep calling the same method to take a job out
      # until the number of jobs taken out meets the demand
      {{:value, job}, queue} -> take_jobs(queue, n - 1, [job | jobs])
    end
  end
end