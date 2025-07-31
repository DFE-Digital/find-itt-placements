require "rails_helper"

RSpec.describe MapComponent, type: :component do
  let(:organisations) do
    [
      create(:school, name: "Hogwarts", longitude: 10.0, latitude: 20.0),
      create(:school, name: "Beauxbatons", longitude: nil, latitude: nil)
    ]
  end
  let(:base_longitude) { 50.0 }
  let(:base_latitude) { 40.0 }

  subject do
    described_class.new(
      organisations: organisations,
      base_longitude: base_longitude,
      base_latitude: base_latitude,
    )
  end

  describe "#render" do
    it "renders the map component with the correct attributes" do
      render_inline(subject)

      expect(page).to have_css("[data-controller='map']")
      expect(page).to have_css("[data-map-key-value='#{ENV.fetch("GOOGLE_MAPS_API_KEY", "")}']")
      expect(page).to have_css("[data-map-base-latitude-value='#{base_latitude}']")
      expect(page).to have_css("[data-map-base-longitude-value='#{base_longitude}']")
      expect(page).to have_css("[data-map-target='organisations']")
      expect(page).to have_css("[data-marker-latitude='#{organisations.first.latitude}']")
      expect(page).to have_css("[data-marker-longitude='#{organisations.first.longitude}']")
      expect(page).to have_css("[data-marker-title='#{organisations.first.name}']")
      expect(page).to have_css("[data-map-target='map']")
    end
  end

  describe "#map_id" do
    it "returns a unique UUID" do
      expect(subject.map_id).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)
    end
  end

  describe "#render?" do
    context "when organisations have valid coordinates" do
      it "returns true" do
        expect(subject.render?).to be true
      end
    end

    context "when all organisations have nil coordinates" do
      let(:organisations) { [ create(:school, longitude: nil, latitude: nil) ] }

      it "returns false" do
        expect(subject.render?).to be false
      end
    end
  end
end
