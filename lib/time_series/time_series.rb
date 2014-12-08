module TimeSeries
  class TimeSeries

    attr_reader :start_time, :interval, :data

    def initialize(start_time, interval, data)
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

  end

  class TimeSeriesCombination
    class StartTimeMismatchError < StandardError; end

    def initialize(*time_series)
      @time_series = time_series
      check_start_time_equality!
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
