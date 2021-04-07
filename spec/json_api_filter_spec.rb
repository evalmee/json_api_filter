RSpec.describe JsonApiFilter do

  before do
    class FakesController
      include ::JsonApiFilter
      permitted_filters  %i[id author]
    end
  end
  after { Object.send :remove_const, :FakesController }
  let(:object) { FakesController.new }
  klass_examples = [
      {
        name: "JsonApiFilter::FieldFilters::Matcher",
        examples: [
          {
            name: 'direct id',
            params: {
              filter: { id: "1,2" }
            },
            request: User.where(id: [1,2])
          }
       ],
      },
      {
        name: "JsonApiFilter::FieldFilters::Compare",
        examples: [
          {
            name: 'eq id',
            params: {
              filter: { id: {eq: 1} }
            },
            request: User.where("id = 1")
          },
          {
            name: 'not eq id',
            params: {
              filter: { id: {ne: 1} }
            },
            request: User.where("id != 1")
          },
          {
            name: 'gt id',
            params: {
              filter: { id: {gt: 1} }
            },
            request: User.where("id > 1")
          },
          {
            name: 'ge id',
            params: {
              filter: { id: {ge: 1} }
            },
            request: User.where("id >= 1")
          },
          {
            name: 'lt id',
            params: {
              filter: { id: {lt: 1} }
            },
            request: User.where("id < 1")
          },
          {
            name: 'le id',
            params: {
              filter: { id: {le: 1} }
            },
            request: User.where("id <= 1")
          },
          {
            name: 'le id and gt id',
            params: {
              filter: {
                id: {
                  gt: 1,
                  lt: 3,
                },
              }
            },
            request: User.where("id > 1").where("id < 3")
          },
          {
            name: 'le id and eq name',
            params: {
              filter: {
                id: {le: 1},
                name: {eq: "foo"}
              }
            },
            request: User.where("id <= 1").where("name = 'foo'")
          }
       ]
      }
    ]


  klass_examples.each do |klass|
  
    describe klass[:name] do
    
      klass[:examples].each do |test_case|
        tc = test_case.with_indifferent_access
        
        it "Filter by #{tc['name']}" do
          expect(object.attr_filter(User, tc['params'])).to eq(tc['request'])
        end
      end
    end
    
  end

end

