Creation:

t = TimeSeries.new(
  data, # Array of Numeric
  start_time,
  interval
)

Manipulation:

t.sum # => sum of all elements
t.average # => average of all elements
t.map_with(other_ts).weighted_average # => weighted average, using other_ts as weights
t.map_with(volume_ts, aht_ts) do |element, volume, aht|
  ErlangC.new(volume, aht, interval_length, awt).service_level
end # => new TimeSeries
t.==(other_ts)
t.legacy_format # => TimeSeriesElementsList.new …
t.process! # = TimeSeriesElementsList.process!

delegate :any?, :each, :none?, :size, to: :@data
