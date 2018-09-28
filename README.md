# Processor commands

```
Enum.map(1..10000, fn i ->
  fn -> IO.puts "performed job #{i}" end
end) |> GenstageFlowTalk.Processor.Producer.enqueue_jobs()
```


# Flow commands

```
GenstageFlowTalk.Flow.PipelineList.run()
GenstageFlowTalk.Flow.PipelineBatch.run()
GenstageFlowTalk.Flow.PipelineBatchReduceStage.run()
GenstageFlowTalk.Flow.PipelineMultiStageBatch.run()
```

# Performance measuring

Based on:

[this](http://teamon.eu/2016/tuning-elixir-genstage-flow-pipeline-processing/) and [this](http://teamon.eu/2016/measuring-visualizing-genstage-flow-with-gnuplot/)

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