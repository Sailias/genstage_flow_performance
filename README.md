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
```


# Performance measuring

http://teamon.eu/2016/tuning-elixir-genstage-flow-pipeline-processing/
http://teamon.eu/2016/measuring-visualizing-genstage-flow-with-gnuplot/