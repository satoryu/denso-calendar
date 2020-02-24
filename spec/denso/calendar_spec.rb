# frozen_string_literal: true

RSpec.describe Denso::Calendar do
  before do
    calendar_path = File.join(SPEC_ROOT, 'fixtures', 'calendar.html')
    stub_request(:get, 'https://www.denso.com/jp/ja/about-us/calendar/')
      .to_return(status: 200, body: File.read(calendar_path))
  end

  describe '.load' do
    it 'contains request' do
      expect(Denso::Calendar.load).to_not be_nil
    end
  end
end
