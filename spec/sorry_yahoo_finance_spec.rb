require 'spec_helper'
require 'pry'
describe SorryYahooFinance do

  it 'should have a version number' do
    expect(SorryYahooFinance::VERSION).not_to be_nil
  end

  describe 'acquiring stock info' do

    context 'arg is just code' do
      subject { SorryYahooFinance::GET(8058) }
      it { is_expected.to be_a(SorryYahooFinance::Info) }
    end

    context 'arg is just codes' do
      subject { SorryYahooFinance::GET([8606,8058]) }
      it { is_expected.to be_a(Array) }
      specify { expect(subject.first).to be_a(SorryYahooFinance::Info) }
    end

    context 'args are code and Date object' do
      subject { SorryYahooFinance::GET(8606, Date.new(2014, 3, 20)) }
      it { is_expected.to be_a(SorryYahooFinance::Info) }
    end

    context 'args are code, year, month and day' do
      subject { SorryYahooFinance::GET(8058, 2014, 3, 20) }
      it { is_expected.to be_a(SorryYahooFinance::Info) }
    end
  end

  describe 'Info' do
    subject { SorryYahooFinance::GET(8058) }
    specify { expect(subject.formalize_values).to be_a(Hash) }
    specify { expect(subject.ja_values).to be_a(Hash) }
  end
end
