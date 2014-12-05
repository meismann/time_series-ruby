class TimeSeries::TimeSeries

  def initialize(data, start_time, interval)
    @data, @start_time, @interval = data, start_time, interval
  end

  def average
    sum.to_f / @data.size
  end

  def sum
    @data.inject(&:+)
  end
end
