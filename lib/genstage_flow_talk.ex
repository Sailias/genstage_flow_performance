defmodule GenstageFlowTalk do
  use Application

  import Supervisor.Spec, warn: false

  def start(_type, _args) do

    children = [
      worker(GenstageFlowTalk.Progress, [
        [
          :processor_producer, 
          :processor_consumer, 
          :miner_producer, 
          :miner_consumer,
          :flow_stream,
          :flow_insert
        ]
      ]),

      worker(GenstageFlowTalk.Processor.Producer, []),
      worker(GenstageFlowTalk.Processor.Consumer, [], id: "Processor.Consumer1"),
      worker(GenstageFlowTalk.Processor.Consumer, [], id: "Processor.Consumer2"),

      # worker(GenstageFlowTalk.Miner.Producer, []),
      # worker(GenstageFlowTalk.Miner.Consumer, [], id: "Miner.Consumer1"),
      # worker(GenstageFlowTalk.Miner.Consumer, [], id: "Miner.Consumer2")
    ]

    opts = [strategy: :one_for_one, name: GenstageFlowTalk.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
