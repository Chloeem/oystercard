require 'oystercard'

describe Oystercard do
  describe '#top_up' do

    it 'can top up the balance' do
      expect { subject.top_up(1) }.to change { subject.balance }.by(1)
    end

    it 'raises an error if the maximum balance is exceeded' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      expect { subject.top_up(1) }.to raise_error("Maximum balance of #{Oystercard::MAXIMUM_BALANCE} exceeded")
    end
  end

  describe '#deduct' do
    
    it 'should deduct money' do
      subject.top_up(20)
      expect { subject.deduct(10) }.to change { subject.balance }.by(-10)
    end
  end

  describe '#touch_in' do
    it 'is initially not in a journey' do
      expect(subject.in_journey).to eq(false)
    end

    it 'can touch in' do
      subject.top_up(1)
      expect(subject.touch_in).to eq(true)
    end

    it 'will not touch in if below minimum balance' do
      expect { subject.touch_in }.to raise_error('Insufficient balance to touch in')
    end
  end

  describe '#touch_out' do
    it 'can touch out' do
      subject.top_up(1)
      subject.touch_in
      expect(subject.touch_out).to eq(false)
    end
  end
end