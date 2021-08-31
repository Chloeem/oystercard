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

  describe '#touch_in' do
    let(:station) { double :station }

    it 'is initially not in a journey' do
      expect(subject.in_journey).to eq(false)
    end

    it 'can touch in' do
      subject.top_up(1)
      expect(subject.touch_in(station)).to eq(station)
      expect(subject.in_journey).to eq(true)
    end

    it 'will not touch in if below minimum balance' do
      expect { subject.touch_in(station) }.to raise_error('Insufficient balance to touch in')
    end

    it 'stores the entry station' do
      subject.top_up(1)
      subject.touch_in(station)
      expect(subject.entry_station).to eq(station)
    end
  end

  describe '#touch_out' do
    let(:station) { double :station }

    it 'can touch out' do
      subject.top_up(1)
      subject.touch_in(station)
      subject.touch_out
      expect(subject.in_journey).to eq(false)
    end

    it 'should deduce money when touching out' do
      subject.top_up(1)
      subject.touch_in(station)
      expect { subject.touch_out }.to change { subject.balance }.by(-Oystercard::MINIMUM_BALANCE)
    end
  end
end