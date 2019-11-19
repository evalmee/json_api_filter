RSpec.describe JsonApiFilter do

  before do
    class FakesController
      include ::JsonApiFilter
      permitted_filters  %i[id author]
    end
  end
  after { Object.send :remove_const, :FakesController }
  let(:object) { FakesController.new }
  let(:params) do
    {
      filter:
        {
          id: "1,2",
          author: "12",
          book: "14"
        }
    }
  end
  let(:output) { {id: %w[1 2], author: %w[12]} }


  describe 'filter_by_attr' do
    it { expect(object.attr_filter(params)).to eq(output) }
  end

end

