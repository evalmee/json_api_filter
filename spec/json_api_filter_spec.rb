RSpec.describe JsonApiFilter do

  before do
    class FakesController
      include ::JsonApiFilter
      permitted_filters  [:id, :author, :name, posts: [:id], articles: [:id]]
      permitted_searches :fake_global_search,
                         name: :fake_name_search
    end
  end

  after do
    Object.send :remove_const, :FakesController
  end

  let(:object) { FakesController.new }
  klass_examples = [
      {
        name: "JsonApiFilter::Dispatch",
        examples: [
          {
            name: 'nothing 😉',
            params: {},
            request: User.all
          },
        ],
      },
      {
        name: "JsonApiFilter::FieldFilters::Matcher",
        examples: [
          {
            name: 'direct id',
            params: {
              filter: { id: "1,2" }
            },
            request: User.where(id: [1,2])
          },
          {
            name: 'empty id',
            params: {
              filter: { id: "" }
            },
            request: User.where(id: '')
          },
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
            request: User.where("id" => "1")
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
            request: User.where("id <= 1").where("name" => "foo")
          }
       ]
      },
      {
        name: "JsonApiFilter::FieldFilters::Searcher",
        examples: [
          {
            name: "global search",
            params: {
              search: "test user"
            },
            request: User.where("name = 'test user'")
          },
          {
            name: "column search",
            params: {
              filter: {
                name: {
                  search: "test user"
                }
              }
            },
            request: User.where("name = 'test user'")
          }
        ]
      },
      {
        name: "JsonApiFilter::FieldFilters::Sorter",
        examples: [
          {
            name: "sort by id",
            params: {
              sort: {
                by: "id"
              }
            },
            request: User.order(:id)
          },
          {
            name: "sort by descending id",
            params: {
              sort: {
                by: "id",
                desc: true
              }
            },
            request: User.order(id: :desc)
          },
          {
            name: "sort by name",
            params: {
              sort: {
                by: "name"
              }
            },
            request: User.order(:name)
          },
        ]
      },
      {
        name: "JsonApiFilter::FieldFilters::Pagination",
        examples: [
          {
            name: "first page with 10 elements",
            params: {
              pagination: {
                page: 1,
                perPage: 10
              }
            },
            request: User.limit(10).offset(0)
          },
          {
            name: "third page with 5 elements",
            params: {
              pagination: {
                page: 3,
                perPage: 5
              }
            },
            request: User.limit(5).offset(10)
          }
        ]
      },
      {
        name: "JsonApiFilter::FieldFilters::Matcher on associations",
        examples: [
                {
                  name: 'direct multiples id',
                  params: {
                    filter: { posts: {id: "1,2"} }
                  },
                  request: User.joins(:posts)
                               .where(posts: {id: [1,2]})
                },
                {
                  name: 'named relationship',
                  params: {
                    filter: { articles: {id: "1,2"} }
                  },
                  request: User.joins(:articles)
                               .where(posts: {id: [1,2]})
                },
                {
                  name: 'direct one id',
                  params: {
                    filter: { posts: {id: "1"} }
                  },
                  request:  User.joins(:posts)
                                .where(posts: {id: 1})
                },
                {
                  name: 'combined',
                  params: {
                    filter: {
                      posts: {id: "1,2"},
                      name: "foo",
                    }
                  },
                  request: User.joins(:posts)
                               .where(posts: {id: [1,2]})
                               .where(name: "foo")
                },
                {
                  name: 'relationship field',
                  params: {
                    filter: {
                      posts: {user_id: "1,2"},
                    }
                  },
                  request: User.joins(:posts)
                               .where(posts: {user_id: [1,2]})
                },
                {
                  name: 'named relationship field',
                  params: {
                    filter: {
                      articles: {user_id: "1,2"},
                    }
                  },
                  request: User.joins(:posts)
                               .where(posts: {user_id: [1,2]})
                },
              ],
      },
    ]


  klass_examples.each do |klass|
  
    describe klass[:name] do
    
      klass[:examples].each do |test_case|
        tc = test_case.with_indifferent_access
        
        
        it "Filter by #{tc['name']}" do
          expect(object.json_api_filter(User, tc['params'])).to eq(tc['request'])
        end
      end
    end
    
  end

end

RSpec.describe "custom filters" do
  before do
    class CustomFiltersController
      include ::JsonApiFilter

      permitted_filters [:id]

      filter :public_name do
        eq { |scope, values| scope.where(name: values) }
        ne { |scope, values| scope.where.not(name: values) }
        gt { |scope, values| scope.where("id > ?", values.first) }
        ge { |scope, values| scope.where("id >= ?", values.first) }
        lt { |scope, values| scope.where("id < ?", values.first) }
        le { |scope, values| scope.where("id <= ?", values.first) }
      end

      filter :public_kind do
        eq do |scope, values|
          mapping = { "writer" => "Alice", "reader" => "Bob" }
          mapped_values = values.map { |value| mapping[value] }

          mapped_values.any?(&:nil?) ? scope.none : scope.where(name: mapped_values)
        end
      end
    end
  end

  after do
    Object.send :remove_const, :CustomFiltersController
  end

  let(:controller) { CustomFiltersController.new }

  it "uses eq for the direct syntax and passes multiple values as an array" do
    params = { filter: { public_name: "Alice,Bob" } }.with_indifferent_access
    result = controller.json_api_filter(User, params)

    expect(result.to_sql).to eq(User.where(name: ["Alice", "Bob"]).to_sql)
  end

  it "uses eq for the explicit operator syntax" do
    params = { filter: { public_name: { eq: "Alice,Bob" } } }.with_indifferent_access

    expect(controller.json_api_filter(User, params).to_sql).to eq(User.where(name: ["Alice", "Bob"]).to_sql)
  end

  {
    ne: User.where.not(name: ["1"]),
    gt: User.where("id > ?", "1"),
    ge: User.where("id >= ?", "1"),
    lt: User.where("id < ?", "1"),
    le: User.where("id <= ?", "1"),
  }.each do |operator, expected_scope|
    it "dispatches the #{operator} operator" do
      params = { filter: { public_name: { operator => "1" } } }.with_indifferent_access

      expect(controller.json_api_filter(User, params).to_sql).to eq(expected_scope.to_sql)
    end
  end

  it "composes custom and permitted filters" do
    params = { filter: { public_name: "Alice", id: "1" } }.with_indifferent_access

    expect(controller.json_api_filter(User, params)).to eq(User.where(name: ["Alice"]).where(id: ["1"]))
  end

  it "does not treat the custom filter name as a column" do
    params = { filter: { public_name: { unsupported: "Alice" } } }.with_indifferent_access

    expect(controller.json_api_filter(User, params)).to eq(User.all)
  end

  it "ignores a supported operator that the custom filter did not declare" do
    params = { filter: { public_kind: { lt: "writer" } } }.with_indifferent_access

    expect(controller.json_api_filter(User, params)).to eq(User.all)
  end

  it "can translate public values" do
    params = { filter: { public_kind: "writer" } }.with_indifferent_access
    result = controller.json_api_filter(User, params)

    expect(result.to_sql).to eq(User.where(name: ["Alice"]).to_sql)
  end

  it "can return an empty scope for an unknown public value" do
    params = { filter: { public_kind: "bogus" } }.with_indifferent_access
    result = controller.json_api_filter(User, params)

    expect(result.to_sql).to eq(User.none.to_sql)
  end

  it "allows a controller with only custom filters" do
    custom_filter_only_controller = Class.new do
      include ::JsonApiFilter

      filter :public_name do
        eq { |scope, values| scope.where(name: values) }
      end
    end

    params = { filter: { public_name: "Alice" } }.with_indifferent_access
    result = custom_filter_only_controller.new.json_api_filter(User, params)

    expect(result.to_sql).to eq(User.where(name: ["Alice"]).to_sql)
  end

  it "inherits filter definitions without mutating its parent" do
    child_controller = Class.new(CustomFiltersController) do
      filter :child_filter do
        eq { |scope, values| scope.where(id: values) }
      end
    end

    expect(child_controller.json_api_custom_filters.keys).to contain_exactly("public_name", "public_kind", "child_filter")
    expect(CustomFiltersController.json_api_custom_filters.keys).to contain_exactly("public_name", "public_kind")
  end
end
