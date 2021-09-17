RSpec.describe JsonApiFilter do
  before do
    class FakesController
      include ::JsonApiFilter
      permitted_filters  [:id, :author, :name, posts: [:id], articles: [:id]]
      permitted_searches :fake_global_search, name: :fake_name_search
      permitted_inclusions %i[posts articles articles.categories]
    end
    User.create(name: "user name")
    User.create(name: "other user name")
    User.create(name: "yet another user name")
  end

  after do
    Object.send :remove_const, :FakesController
    User.delete_all
  end

  describe "#json_api_inclusions" do
    let(:controller)  { FakesController.new }

    context "no include params" do
      let(:params)      { {} }

      it "returns no inclusions" do
        expect(controller.json_api_inclusions(params)).to be_empty
      end
    end

    context "one include params" do
      let(:params)      { { include: "posts" } }

      it "returns one inclusion" do
        expect(controller.json_api_inclusions(params)).to eq([:posts])
      end
    end

    context "unallowed include params" do
      let(:params)      { { include: "passwords" } }

      it "returns no inclusions" do
        expect { controller.json_api_inclusions(params) }.to raise_error(JsonApiFilter::UnknownInclusions)
      end
    end

    context "unallowed + allowed include params" do
      let(:params)      { { include: "passwords,posts" } }

      it "returns only allowed inclusions" do
        expect { controller.json_api_inclusions(params) }.to raise_error(JsonApiFilter::UnknownInclusions)
      end
    end

    context "multiples unallowed + allowed include params" do
      let(:params)      { { include: "passwords,posts,articles,ip_addresses" } }

      it "returns only allowed inclusions" do
        expect { controller.json_api_inclusions(params) }.to raise_error(JsonApiFilter::UnknownInclusions)
      end
    end

    context "multiples unallowed + allowed + relationship paths include params" do
      let(:params)      { { include: "passwords,posts,articles,ip_addresses,articles.categories" } }

      it "returns only allowed inclusions and paths" do
        expect { controller.json_api_inclusions(params) }.to raise_error(JsonApiFilter::UnknownInclusions)
      end
    end

    context "duplicates include params" do
      let(:params)      { { include: "posts,posts,articles.categories,articles.categories" } }

      it "ignores duplicates" do
        expect(controller.json_api_inclusions(params)).to eq([:posts, :"articles.categories"])
      end
    end
  end
end