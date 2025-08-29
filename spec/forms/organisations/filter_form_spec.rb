require "rails_helper"

describe Organisations::FilterForm, type: :model do
  include Rails.application.routes.url_helpers

  describe "#filters_selected?" do
    subject(:filters_selected) { described_class.new(params).filters_selected? }

    context "when given search location params" do
      context "when search location an empty string" do
        let(:params) { { search_location: "" } }

        it "return false" do
          expect(filters_selected).to be(false)
        end
      end

      context "when search location not an empty string" do
        let(:params) { { search_location: "London" } }

        it "return true" do
          expect(filters_selected).to be(true)
        end
      end
    end

    context "when given search distance params" do
      context "when search location an empty string" do
        let(:params) { { search_distance: "" } }

        it "return false" do
          expect(filters_selected).to be(false)
        end
      end

      context "when search location not an empty string" do
        let(:params) { { search_distance: "20" } }

        it "return true" do
          expect(filters_selected).to be(true)
        end
      end
    end

    context "when given search by name params" do
      context "when search by name an empty string" do
        let(:params) { { search_by_name: "" } }

        it "return false" do
          expect(filters_selected).to be(false)
        end
      end

      context "when search by name a non-empty string" do
        let(:params) { { search_by_name: "Hogwarts" } }

        it "returns true" do
          expect(filters_selected).to be(true)
        end
      end
    end

    context "when given phase params" do
      let(:params) { { phases: %w[primary secondary] } }

      it "returns true" do
        expect(filters_selected).to be(true)
      end
    end

    context "when given itt statuses params" do
      let(:params) { { itt_statuses: %w[open not_open] } }

      it "returns true" do
        expect(filters_selected).to be(true)
      end
    end

    context "when given no params" do
      let(:params) { {} }

      it "returns false" do
        expect(filters_selected).to be(false)
      end
    end
  end

  describe "#clear_filters_path" do
    subject(:filter_form) { described_class.new }

    it "returns the find index page path" do
      expect(filter_form.clear_filters_path).to eq(organisations_path)
    end
  end

  describe "index_path_without_filter" do
    subject(:filter_form) { described_class.new(params) }

    context "when removing search location params" do
      let(:params) do
        { search_location: "London" }
      end

      it "returns the find index page path without the given search location param" do
        expect(
          filter_form.index_path_without_filter(
            filter: "search_location",
            value: "London",
          ),
        ).to eq(organisations_path(filters: { schools_to_show: "active" }))
      end
    end

    context "when removing search by name params" do
      let(:params) do
        { search_by_name: "Hogwarts" }
      end

      it "returns the find index page path without the given search by name param" do
        expect(
          filter_form.index_path_without_filter(
            filter: "search_by_name",
            value: "Hogwarts",
          ),
        ).to eq(organisations_path(filters: { schools_to_show: "active" }))
      end
    end

    context "when removing phase params" do
      let(:params) do
        { phases: %w[primary secondary] }
      end

      it "returns the find index page path without the given phase param" do
        expect(
          filter_form.index_path_without_filter(
            filter: "phases",
            value: "primary",
          ),
        ).to eq(organisations_path(filters: { phases: [ "secondary" ], schools_to_show: "active"  }))
      end
    end

    context "when removing itt statuses params" do
      let(:params) do
        { itt_statuses: %w[open not_open] }
      end

      it "returns the find index page path without the given itt statuses param" do
        expect(
          filter_form.index_path_without_filter(
            filter: "itt_statuses",
            value: "open",
          ),
        ).to eq(organisations_path(filters: { itt_statuses: [ "not_open" ], schools_to_show: "active" }))
      end
    end
  end

  describe "#query_params" do
    it "returns the expected result" do
      expect(described_class.new.query_params).to eq(
        {
          search_location: nil,
          search_by_name: nil,
          search_distance: nil,
          schools_to_show: "active",
          subject_ids: [],
          itt_statuses: [],
          phases: []
        },
      )
    end
  end

  describe "#primary_selected?" do
    subject(:filter_form) { described_class.new(params) }

    context "when primary is selected" do
      let(:params) { { phases: %w[Primary] } }

      it "returns true" do
        expect(filter_form.primary_selected?).to be(true)
      end
    end

    context "when primary is not selected" do
      let(:params) { { phases: %w[Secondary] } }

      it "returns false" do
        expect(filter_form.primary_selected?).to be(false)
      end
    end
  end

  describe "#secondary_selected?" do
    subject(:filter_form) { described_class.new(params) }

    context "when secondary is selected" do
      let(:params) { { phases: %w[Secondary] } }

      it "returns true" do
        expect(filter_form.secondary_selected?).to be(true)
      end
    end

    context "when secondary is not selected" do
      let(:params) { { phases: %w[Primary] } }

      it "returns false" do
        expect(filter_form.secondary_selected?).to be(false)
      end
    end
  end

  describe "#primary_only?" do
    subject(:filter_form) { described_class.new(params) }

    context "when only primary is selected" do
      let(:params) { { phases: %w[Primary] } }

      it "returns true" do
        expect(filter_form.primary_only?).to be(true)
      end
    end

    context "when secondary is also selected" do
      let(:params) { { phases: %w[Primary Secondary] } }

      it "returns false" do
        expect(filter_form.primary_only?).to be(false)
      end
    end
  end

  describe "#secondary_only?" do
    subject(:filter_form) { described_class.new(params) }

    context "when only secondary is selected" do
      let(:params) { { phases: %w[Secondary] } }

      it "returns true" do
        expect(filter_form.secondary_only?).to be(true)
      end
    end

    context "when primary is also selected" do
      let(:params) { { phases: %w[Primary Secondary] } }

      it "returns false" do
        expect(filter_form.secondary_only?).to be(false)
      end
    end
  end
end
