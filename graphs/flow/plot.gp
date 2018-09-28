# plot.gp
# output to png with decend font and image size
set terminal png font "Arial,10" size 700,500
set output "progress.png"

set title "Elixir Flow processing progress over time"
set xlabel "Time (ms)"
set ylabel "Items processed"
set key top left # put labels in top-left corner

# limit x range to 15.000 ms instead of dynamic one, must-have
# when generating few graphs that will be later compared visually
set xrange [0:40000]
set yrange [0:3000]

# plot series (see below for explanation)
# plot [file] with [line type] ls [line style id] [title ...  | notitle]

plot  "../../log/progress-flow_stream.log" with steps  ls 1 title "Select",\
      "../../log/progress-flow_stream.log" with points ls 1 notitle,\
      "../../log/progress-flow_insert.log" with steps  ls 2 title "Insert",\
      "../../log/progress-flow_insert.log" with points ls 2 notitle,