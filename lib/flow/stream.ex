defmodule GenstageFlowTalk.Flow.Stream do
  
  @max_interations 50
  @select_count 50

  def get_stream do
    Stream.resource(
      fn -> 0 end,
      fn accumulator ->
        if accumulator >= @max_interations do
          {:halt, accumulator}
        else
          { get_records(accumulator), accumulator + 1 }
        end
      end,
      fn _ -> nil end
    )
  end

  def get_records(num) do
    :timer.sleep(@select_count * 5)
    GenstageFlowTalk.Progress.incr(:flow_stream, @select_count)

    Enum.map(1..@select_count, fn i ->
      %{
        user_name: "#{ num }_#{ i }",
        orders: [
          %{ amount: :rand.uniform() * 100 },
          %{ amount: :rand.uniform() * 100 },
          %{ amount: :rand.uniform() * 100 },
          %{ amount: :rand.uniform() * 100 }
        ]
      }
    end)
  end

end