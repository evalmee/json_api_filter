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

