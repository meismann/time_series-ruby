require 'spec_helper'

describe TimeSeries::TimeSeries do

  let(:start_time) { Time.now }
  let(:interval) { 60 }
  let(:data) { [0, 1, 2, 3] }

  subject { described_class.new start_time, interval, data }

  its(:average) { is_expected.to eq 1.5 }

  its(:sum) { is_expected.to eq 6 }

  describe '#map_with(other).weighted_average' do
    let(:other) { described_class.new start_time, interval, [0, 0, 8, 2] }

    it 'returns the weighted average' do
      expect(subject.map_with(other).weighted_average).to eq 2.2
    end
  end

  describe '#map_with(other1, other2, …)' do
    let(:data) { [0, 1] }
    let(:other1) { described_class.new start_time, interval, [2, 3] }
    let(:other2) { described_class.new start_time, interval, [4, 5] }

    it 'yields with all values at the same index' do
      expect{ |b| subject.map_with(other1, other2, &b) }.to yield_successive_args(
        [0, 2, 4],
        [1, 3, 5]
      )
    end
  end

end
