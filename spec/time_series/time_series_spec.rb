require 'spec_helper'

describe TimeSeries::TimeSeries do

  let(:data) { (0..9).to_a }

  subject { described_class.new data, Time.now, 60 }

  its(:average) { is_expected.to eq 4.5 }

  its(:sum) { is_expected.to eq 45 }
end
