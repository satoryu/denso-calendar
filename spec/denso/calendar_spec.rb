# frozen_string_literal: true

RSpec.describe Denso::Calendar do
  describe '.load' do
    before do
      calendar_path = File.join(SPEC_ROOT, 'fixtures', 'calendar.html')
      stub_request(:get, 'https://www.denso.com/jp/ja/about-us/calendar/')
        .to_return(status: 200, body: File.read(calendar_path))
    end
    let(:calendar) { Denso::Calendar.load }

    it 'contains request' do
      expect(calendar).to be_a(Denso::Calendar)
    end
    specify 'its Nov. 23 is not holiday' do
      expect(calendar.holidays).to_not include(Date.new(2020, 11, 23))
    end

    context 'When loading tokyo calendar' do
      specify 'its november 23 is holiday' do
        expect(Denso::Calendar.load(:tokyo).holidays).to include(Date.new(2020, 11, 23))
      end
    end
  end

  let(:content) { <<-CONTENT }
    <div class="denso-calendar">
      <table summary="2020年11月 休日カレンダー">
        <caption>2020年11月</caption>
        <tbody>
          <tr>
            <th scope="col">日</th>
            <th scope="col">月</th>
            <th scope="col">火</th>
            <th scope="col">水</th>
            <th scope="col">木</th>
            <th scope="col">金</th>
            <th scope="col">土</th>
          </tr>
          <tr>
            <td class="holiday">1</td>
            <td>2</td>
            <td>3</td>
            <td>4</td>
            <td>5</td>
            <td>6</td>
            <td class="holiday">7</td>
          </tr>
          <tr>
            <td class="holiday">8</td>
            <td>9</td>
            <td>10</td>
            <td>11</td>
            <td>12</td>
            <td>13</td>
            <td class="holiday">14</td>
          </tr>
          <tr>
            <td class="holiday">15</td>
            <td>16</td>
            <td>17</td>
            <td>18</td>
            <td>19</td>
            <td>20</td>
            <td class="holiday">21</td>
          </tr>
          <tr>
            <td class="holiday">22</td>
            <td>23</td>
            <td>24</td>
            <td>25</td>
            <td>26</td>
            <td>27</td>
            <td class="holiday">28</td>
          </tr>
          <tr>
            <td class="holiday">29</td>
            <td>30</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </tbody>
      </table>
    </div>
  CONTENT
  let(:table) { Nokogiri::HTML(content) }
  let(:calendar) { Denso::Calendar.new(table) }

  describe '#days' do
    it 'returns an array of Date object' do
      expect(calendar.days).to all be_a(Date)
    end
    it 'returns 30 days' do
      expect(calendar.days.length).to be 30
    end
  end

  describe '#hodays' do
    it 'returns an array of Date object' do
      expect(calendar.holidays).to all be_a(Date)
    end
    it 'contains holidays in the calendar' do
      novembers_holidays = %w[1 7 8 14 15 21 22 28 29].map { |d| Date.new(2020, 11, d.to_i) }

      expect(calendar.holidays).to match_array(novembers_holidays)
    end
  end

  describe '#business_days' do
    it 'returns an array of Date object' do
      expect(calendar.business_days).to all be_a(Date)
    end
  end
end
