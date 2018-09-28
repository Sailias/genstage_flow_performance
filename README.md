# Processor commands

The processor GenStage implementation is a producer that you can push events to.

```
GenstageFlowTalk.Processor.Producer.enqueue_jobs([fn -> IO.puts("hello")])
```

```
iex -S mix
Enum.map(1..10000, fn i ->
  fn -> IO.puts "performed job #{i}" end
end) |> GenstageFlowTalk.Processor.Producer.enqueue_jobs()
```

# Miner

A miner is a producer that fetches events from an external source.
This could be an API, a Redis Queue or whatever.

The external queue is simulated by `GenstageFlowTalk.Miner.EventGenerator`

A miner will fetch jobs until it satisfies the demand, 
or will queue a check for more events every 1 second if the external source isn't returning anything.

Uncomment in `genstage_flow_talk.ex`
```
# worker(GenstageFlowTalk.Miner.Producer, []),
# worker(GenstageFlowTalk.Miner.Consumer, [], id: "Miner.Consumer1"),
# worker(GenstageFlowTalk.Miner.Consumer, [], id: "Miner.Consumer2")
```

# Flow commands

The Flow implementation simulates pulling records from a database, aggregating their data and writing them
somewhere else.

I have included 4 different Flow pipelines.  Each one uses common Flow patterns and each one is
more efficient than the previous.


```
GenstageFlowTalk.Flow.PipelineList.run()
GenstageFlowTalk.Flow.PipelineBatch.run()
GenstageFlowTalk.Flow.PipelineBatchReduceStage.run()
GenstageFlowTalk.Flow.PipelineMultiStageBatch.run()
```

# Performance measuring

Based on: [this](http://teamon.eu/2016/tuning-elixir-genstage-flow-pipeline-processing/) and [this](http://teamon.eu/2016/measuring-visualizing-genstage-flow-with-gnuplot/)

Look at your log files, check the time stamps.

```
0 0
9272  100
9772  200
11027 300
11273 400
11529 500
12527 600
```

You'll want to adjust your [X,Y] values in the `plot.gp` files.
For example using the data above:

```
set xrange [0:15000]
set yrange [0:700]
```

```
cd graphs/miner/
gnuplot plot.gp
```

```
cd graphs/processor/
gnuplot plot.gp
```

```
cd graphs/flow/
gnuplot plot.gp
```