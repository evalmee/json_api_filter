RSpec.describe JsonApiFilter do
  before do
    class FakesController
      include ::JsonApiFilter
      permitted_inclusions %i[posts articles articles.categories]
    end

    class NoInclusionsController
      include ::JsonApiFilter
    end
  end

  after do
    Object.send :remove_const, :FakesController
    Object.send :remove_const, :NoInclusionsController
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

      it "raise an unknown inclusions error" do
        expect { controller.json_api_inclusions(params) }.to raise_error(JsonApiFilter::UnknownInclusionsError)
      end
    end

    context "unallowed + allowed include params" do
      let(:params)      { { include: "passwords,posts" } }

      it "raise an unknown inclusions error" do
        expect { controller.json_api_inclusions(params) }.to raise_error(JsonApiFilter::UnknownInclusionsError)
      end
    end

    context "multiples unallowed + allowed include params" do
      let(:params)      { { include: "passwords,posts,articles,ip_addresses" } }

      it "returns only allowed inclusions" do
        expect { controller.json_api_inclusions(params) }.to raise_error(JsonApiFilter::UnknownInclusionsError)
      end
    end

    context "multiples unallowed + allowed + relationship paths include params" do
      let(:params)      { { include: "passwords,posts,articles,ip_addresses,articles.categories" } }

      it "raise an unknown inclusions error" do
        expect { controller.json_api_inclusions(params) }.to raise_error(JsonApiFilter::UnknownInclusionsError)
      end
    end

    context "duplicates include params" do
      let(:params)      { { include: "posts,posts,articles.categories,articles.categories" } }

      it "ignores duplicates" do
        expect(controller.json_api_inclusions(params)).to eq([:posts, :"articles.categories"])
      end
    end

    context "controller has no inclusions" do
      let(:controller) { NoInclusionsController.new }
      let(:params)      { { include: "posts" } }

      it "raises a missing permitted inclusion error" do
        expect { controller.json_api_inclusions(params) }.to raise_error(JsonApiFilter::MissingPermittedInclusionError)
      end
    end
  end
end