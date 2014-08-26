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
    specify do
      expect(subject.ja_values.keys).to eq(
        [
          "証券コード", "銘柄名", "取引市場", "業種", "株価", "前日終値", "始値", "高値", "安値", "出来高", "売買代金", "値幅制限", "信用買残", "信用売残", "信用買残前週比", "信用売残前週比", "貸借倍率", "時価総額", "発行済株式数", "配当利回り（会社予想）", "1株配当（会社予想）", "PER（会社予想）", "PBR（実績）", "EPS（会社予想）", "BPS（実績）", "最低購入代金", "単元株数", "年初来高値", "年初来安値", "チャート図"
        ]
      )
    end
  end
end
