defmodule GenstageFlowTalk.Miner.EventGenerator do

  def generate_events(max) do
    Enum.map(1..max, fn i ->
      fn -> IO.puts "performed MINER job #{i}" end
    end)
  end

end