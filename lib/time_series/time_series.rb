require 'date'

module TimeSeries
  class TimeSeries

    attr_reader :start_time, :interval, :data

    def initialize(start_time, interval, data)
      if Date === start_time
        warn Kernel.caller.first + <<-WARNING
          Do not call #{self.class}.new with a Date, \
          rather use Time or ActiveSupport::TimeWithZone. \
          Date #{start_time} gets converted to Time #{start_time.to_time}.
        WARNING
        start_time = start_time.to_time
      end

      @start_time, @interval, @data = start_time, interval, data
    end

    def average
      sum.to_f / @data.size
    end

    def sum
      @data.inject(&:+)
    end

    def map_with(*time_series, &block)
      combination = ::TimeSeries::TimeSeriesCombination.new(self, *time_series)
      return combination.map(&block) if block

      combination
    end

    def to_time_series_elements_list
      TimeSeriesElementsList.new data.map.with_index{ |value, index|
        TimeSeriesElement.new value: value, timestamp: start_time + interval * index
      }
    end
  end

  class TimeSeriesCombination
    class StartTimeMismatchError < StandardError; end
    class IntervalMismatchError < StandardError; end
    class DataLengthMismatchError < StandardError; end

    def initialize(*time_series)
      @time_series = time_series
      check_start_time_equality!
      check_interval_equality!
      check_data_length_equality!
    end

    def map
      data_combined = zipDataIterator.map do |values_combined|
        yield *values_combined
      end
      newTimeSeries(data_combined)
    end

    def weighted_average
      weighted_sum = zipDataIterator.inject(0) do |_weighted_sum, values|
        _weighted_sum += values[0] * values[1]
      end
      weighted_sum.to_f / secondary_ts.first.sum
    end

  private

    def check_data_length_equality!
      data_lengths = @time_series.lazy.map(&:data).map(&:size).force
      not data_lengths.uniq.size == 1 and raise DataLengthMismatchError
    end

    def check_interval_equality!
      intervals = @time_series.map(&:interval)
      not intervals.uniq.size == 1 and raise IntervalMismatchError
    end

    def check_start_time_equality!
      start_times = @time_series.lazy.map(&:start_time).map(&:to_time).force
      not start_times.uniq.size == 1 and raise StartTimeMismatchError
    end

    def newTimeSeries(data)
      TimeSeries.new(primary_ts.start_time, primary_ts.interval, data)
    end

    def primary_ts
      @time_series.first
    end

    def secondary_ts
      @time_series[1..-1]
    end

    def zipDataIterator
      secondaries_data = secondary_ts.map(&:data)
      primary_ts.data.zip(*secondaries_data)
    end

  end
end
