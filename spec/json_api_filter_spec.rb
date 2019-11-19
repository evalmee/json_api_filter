# RSpec.describe JsonApiFilter do
#   it "has a version number" do
#     expect(JsonApiFilter::VERSION).not_to be nil
#   end
#
#   it "does something useful" do
#     expect(false).to eq(true)
#   end
# end


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
    it { expect(object.filter_by_attr(params)).to eq(output) }
  end

end


RSpec.describe JsonApiFilter::FilterBy do
  describe 'toto' do
    it do
      expect(
        JsonApiFilter::FilterBy.new(:id, '1,2,3,4').to_hash
      ).to eq(
             {id: %w[1 2 3 4]}
           )
    end
  end
end

RSpec.describe JsonApiFilter::Filters do

  let(:allowed_filter) { [:id, :author, :kind] }
  let(:params) { {filter: {id: "1,2", author: "12", book: "14"} } }
  let(:output) { {id: %w[1 2], author: %w[12]} }

  describe 'toto' do
    it do
      expect(
        JsonApiFilter::Filters.new(allowed_filter, params).to_hash
      ).to eq(output)
    end
  end
end

