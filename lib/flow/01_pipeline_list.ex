defmodule GenstageFlowTalk.Flow.PipelineList do
  @moduledoc """
  Create a single consumer.

  Diagram:

  [stream] -> [Map consumers] -> Enum -> Insert

  This will run the entire Flow, convert it to a list and insert it all at once

  """

  alias GenstageFlowTalk.Flow.Stream

  def run do
    Stream.get_stream()
    |> Flow.from_enumerable()

    # Create single set of consumers
    |> Flow.map(fn user ->
      %{
        user_name: user[:user_name],
        order_total:
          user[:orders]
          |> Enum.reduce(0, fn order, acc -> acc + order[:amount] end)
      }
    end)
    |> Enum.to_list()
    |> insert_records()

    :ok
  end

  defp insert_records(records) do
    IO.inspect(length(records), label: "Inserting records")
    GenstageFlowTalk.Progress.incr(:flow_insert, length(records))
    :timer.sleep(length(records) * 15)
  end

end