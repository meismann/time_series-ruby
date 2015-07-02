A small gem to manipulate timeseries (timestamp-value-pairs). It is rather basic but provides functionality for you to build on top. Feel free to contribute.

Creation of a TimeSeries:
```ruby
t = TimeSeries::TimeSeries.new(
  start_time, # Time or ActiveSupport::TimeWithZone
  interval, # a Numeric that should be understood by Time#+
  data # Array of Numeric
)
```

These do what you expect:

```ruby
t.sum # => sum of all elements
t.average # => average of all elements
```

You can combine time series with each other to perform additional calculations, like calculating a weighted average…
```ruby
t.map_with(other_ts).weighted_average # => weighted average, using other_ts as weights
```
… or the population increase/decrease in a city, country etc.:
```ruby
population_delta_ts = births_ts.map_with(
  deaths_ts,
  immigration_ts,
  emigration_ts
) do |births, deaths, immigrants, emigrants|
  births - deaths + immigrants - emigrants
end
```
