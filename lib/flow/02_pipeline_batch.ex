defmodule GenstageFlowTalk.Flow.PipelineBatch do
  @moduledoc """
  The problem is if we do:

  Flow.map(&insert_records/1)

  That will pass a single record to insert, and we want to insert as a batch.
  So we need a way to group multiple events.

  Diagram:

  [stream] -> [Map1/Reduce1 producer-consumers] -> [Map2 consumers]

  The first stage maps and reduces.  
  Reduce will reduce the values of the current window, which is all the Flow.map values.
  So this will fetch all data, map it, and reduce it.
  Then it emits the state as an array.

  The problem here is that we don't start writing data until all records have been mapped and reduced
  """

  alias GenstageFlowTalk.Flow.Stream

  def run do
    Stream.get_stream()
    |> Flow.from_enumerable()

    # Create our aggregated data structure
    |> Flow.map(fn user ->
      %{
        user_name: user[:user_name],
        order_total:
          user[:orders]
          |> Enum.reduce(0, fn order, acc -> acc + order[:amount] end)
      }
    end)

    # Create a new state and combine them into a list
    |> Flow.reduce(fn -> [] end, fn item, list -> [item | list] end)

    # Emit the state as a list
    |> Flow.emit(:state)

    # Start a new stage that receives lists as arguments
    |> Flow.partition(max_demand: 2, stages: 4)

    # Insert batches of records
    |> Flow.map(&insert_records/1)
    |> Flow.run()

    :ok
  end

  # [file stream] -> [M1] -> [R1] -> [M2]

  defp insert_records(records) do
    IO.inspect(length(records), label: "Inserting records", limit: :infinity)
    GenstageFlowTalk.Progress.incr(:flow_insert, length(records))
    :timer.sleep(length(records) * 15)
  end

end