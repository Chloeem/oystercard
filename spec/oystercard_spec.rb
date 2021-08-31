require 'oystercard'

describe Oystercard do
  before do
    subject.top_up(Oystercard::MAXIMUM_BALANCE - 1)
  end

  describe '#top_up' do

    it 'can top up the balance' do
      expect { subject.top_up(1) }.to change { subject.balance }.by(1)
    end

    it 'raises an error if the maximum balance is exceeded' do
      expect { subject.top_up(2) }.to raise_error("Maximum balance of #{Oystercard::MAXIMUM_BALANCE} exceeded")
    end
  end

  describe '#deduct' do
    
    it 'should deduct money' do
      expect { subject.deduct(10) }.to change { subject.balance }.by(-10)
    end
  end

  describe 'tracking' do
    it 'is initially not in a journey' do
      expect(subject.in_journey).to eq(false)
    end

    it 'can touch in' do
      expect(subject.touch_in).to eq(true)
    end

    it 'can touch out' do
      subject.touch_in
      expect(subject.touch_out).to eq(false)
    end
  end
end