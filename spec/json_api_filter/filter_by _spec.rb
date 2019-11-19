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

