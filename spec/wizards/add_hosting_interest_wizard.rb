require "rails_helper"

RSpec.describe AddHostingInterestWizard do
  subject(:wizard) { described_class.new(state:, params:, school:, current_step:, current_user:) }

  let(:school) { create(:school) }
  let(:state) { {} }
  let(:params_data) { {} }
  let(:params) { ActionController::Parameters.new(params_data) }
  let(:current_step) { nil }
  let(:current_user) { create(:user) }

  describe "#steps" do
    subject(:steps) { wizard.steps.keys }

    it { is_expected.to eq %i[appetite] }

    context "when the appetite is set to 'actively_looking' during the appetite step" do
      let(:state) do
        {
          "appetite" => { "appetite" => "actively_looking" }
        }
      end

      it { is_expected.to eq %i[appetite phase school_contact check_your_answers] }

      context "when the phase is set to 'Primary' during the phase step" do
        let(:state) do
          {
            "appetite" => { "appetite" => "actively_looking" },
            "phase" => { "phases" => %w[primary] }
          }
        end

        it {
          expect(steps).to eq(
            %i[appetite
               phase
               year_group_selection
               school_contact
               check_your_answers],
          )
        }
      end

      context "when the phase is set to 'Secondary' during the phase step" do
        let(:state) do
          {
            "appetite" => { "appetite" => "actively_looking" },
            "phase" => { "phases" => %w[secondary] }
          }
        end

        it {
          expect(steps).to eq(
            %i[appetite
               phase
               secondary_subject_selection
               school_contact
               check_your_answers],
          )
        }

        context "when the subject selected has child subjects" do
          let(:modern_languages) { create(:placement_subject, :secondary, name: "Modern Languages") }
          let(:french) { create(:placement_subject, :secondary, name: "French", parent_subject: modern_languages) }
          let(:state) do
            {
              "appetite" => { "appetite" => "actively_looking" },
              "phase" => { "phases" => %w[secondary] },
              "secondary_subject_selection" => { "subject_ids" => [ modern_languages.id ] }
            }
          end

          before { french }

          it {
            expect(steps).to eq(
              [
                :appetite,
                :phase,
                :secondary_subject_selection,
                "secondary_child_subject_selection_#{modern_languages.id}".to_sym,
                :school_contact,
                :check_your_answers
              ]
            )
          }
        end
      end

      context "when the phase is set to 'Primary' and 'Secondary' during the phase step" do
        let(:state) do
          {
            "appetite" => { "appetite" => "actively_looking" },
            "phase" => { "phases" => %w[primary secondary] }
          }
        end

        it {
          expect(steps).to eq(
            %i[appetite
               phase
               year_group_selection
               secondary_subject_selection
               school_contact
               check_your_answers],
          )
        }
      end
    end

    context "when the appetite is set to 'not_open' during the appetite step" do
      let(:state) do
        {
          "appetite" => { "appetite" => "not_open" }
        }
      end

      it { is_expected.to eq %i[appetite reason_not_hosting school_contact are_you_sure] }
    end

    context "when an appetite is set to 'interested' during the appetite step" do
      let(:state) do
        {
          "appetite" => { "appetite" => "interested" }
        }
      end

      it { is_expected.to eq %i[appetite phase note_to_providers school_contact confirm] }
    end
  end

  describe "#add_placement_preference" do
    subject(:add_placement_preference) { wizard.add_placement_preference }

    before { school }

    context "when the attributes passed are valid" do
      context "when the appetite is 'actively_looking'" do
        context "when the phase selected is 'Primary'" do
          let(:state) do
            {
              "appetite" => { "appetite" => "actively_looking" },
              "phase" => { "phases" => %w[primary] },
              "year_group_selection" => { "year_groups" => %w[reception year_3 mixed_year_groups] },
              "school_contact" => {
                "first_name" => "Joe",
                "last_name" => "Bloggs",
                "email_address" => "joe_bloggs@example.com"
              }
            }
          end

          it "creates an actively looking placement preference record with primary preferences" do
            expect { add_placement_preference }.to change(PlacementPreference, :count).by(1)
            school.reload

            placement_preferences = school.placement_preferences.last
            expect(placement_preferences.appetite).to eq("actively_looking")
            expect(placement_preferences.placement_details).to eq(state)
          end
        end

        context "when the phase selected is 'Secondary'" do
          let(:english) { create(:placement_subject, :secondary, name: "English") }
          let(:mathematics) { create(:placement_subject, :secondary, name: "Mathematics") }
          let(:state) do
            {
              "appetite" => { "appetite" => "actively_looking" },
              "phase" => { "phases" => %w[secondary] },
              "secondary_subject_selection" => { "subject_ids" => [ english.id, mathematics.id ] },
              "school_contact" => {
                "first_name" => "Joe",
                "last_name" => "Bloggs",
                "email_address" => "joe_bloggs@example.com"
              }
            }
          end

          it "creates an actively looking placement preference record with secondary preferences" do
            expect { add_placement_preference }.to change(PlacementPreference, :count).by(1)
            school.reload

            placement_preferences = school.placement_preferences.last
            expect(placement_preferences.appetite).to eq("actively_looking")
            expect(placement_preferences.placement_details).to eq(state)
          end

          context "when a selected subject has child subjects" do
            let(:statistics) { create(:placement_subject, :secondary, name: "Statistics", parent_subject: mathematics) }
            let(:mechanics) { create(:placement_subject, :secondary, name: "Mechanics", parent_subject: mathematics) }
            let(:state) do
              {
                "appetite" => { "appetite" => "actively_looking" },
                "phase" => { "phases" => %w[secondary] },
                "secondary_subject_selection" => { "subject_ids" => [ english.id, mathematics.id ] },
                "secondary_child_subject_selection_#{mathematics.id}" => {
                  "child_subject_ids" => [ statistics.id, mechanics.id ]
                },
                "school_contact" => {
                  "first_name" => "Joe",
                  "last_name" => "Bloggs",
                  "email_address" => "joe_bloggs@example.com"
                }
              }
            end

            it "creates an actively looking placement preference record with secondary preferences with child subjects" do
              expect { add_placement_preference }.to change(PlacementPreference, :count).by(1)
              school.reload

              placement_preferences = school.placement_preferences.last
              expect(placement_preferences.appetite).to eq("actively_looking")
              expect(placement_preferences.placement_details).to eq(state)
            end
          end
        end

        context "when the phase selected is 'Primary' and 'Secondary'" do
          let(:english) { create(:placement_subject, :secondary, name: "English") }
          let(:mathematics) { create(:placement_subject, :secondary, name: "Mathematics") }
          let(:state) do
            {
              "appetite" => { "appetite" => "actively_looking" },
              "phase" => { "phases" => %w[primary secondary] },
              "year_group_selection" => { "year_groups" => %w[reception year_3 mixed_year_groups] },
              "secondary_subject_selection" => { "subject_ids" => [ english.id, mathematics.id ] },
              "school_contact" => {
                "first_name" => "Joe",
                "last_name" => "Bloggs",
                "email_address" => "joe_bloggs@example.com"
              }
            }
          end

          it "creates an actively looking placement preference record with primary and secondary preferences" do
            expect { add_placement_preference }.to change(PlacementPreference, :count).by(1)
            school.reload

            placement_preferences = school.placement_preferences.last
            expect(placement_preferences.appetite).to eq("actively_looking")
            expect(placement_preferences.placement_details).to eq(state)
          end
        end
      end

      context "when the appetite is 'interested'" do
        let(:english) { create(:placement_subject, :secondary, name: "English") }
        let(:mathematics) { create(:placement_subject, :secondary, name: "Mathematics") }
        let(:state) do
          {
            "appetite" => { "appetite" => "interested" },
            "phase" => { "phases" => %w[primary secondary] },
            "year_group_selection" => { "year_groups" => %w[reception year_3 mixed_year_groups] },
            "secondary_subject_selection" => { "subject_ids" => [ english.id, mathematics.id ] },
            "note_to_providers" => { "note" => "Will accept additional placements" },
            "school_contact" => {
              "first_name" => "Joe",
              "last_name" => "Bloggs",
              "email_address" => "joe_bloggs@example.com"
            }
          }
        end

        it "creates an actively looking placement preference record with primary and secondary preferences" do
          expect { add_placement_preference }.to change(PlacementPreference, :count).by(1)
          school.reload

          placement_preferences = school.placement_preferences.last
          expect(placement_preferences.appetite).to eq("interested")
          expect(placement_preferences.placement_details).to eq(state)
        end
      end

      context "when the appetite is 'not_open'" do
        let(:state) do
          {
            "appetite" => { "appetite" => "not_open" },
            "reason_not_hosting" => {
              "reasons_not_hosting" => [
                "Not enough trained mentors",
                "Number of pupils with SEND needs",
                "Working to improve our OFSTED rating"
              ]
            },
            "school_contact" => {
              "first_name" => "Joe",
              "last_name" => "Bloggs",
              "email_address" => "joe_bloggs@example.com"
            }
          }
        end

        it "creates a not open placement preference record with reasons not hosting" do
          expect { add_placement_preference }.to change(PlacementPreference, :count).by(1)
          school.reload

          placement_preferences = school.placement_preferences.last
          expect(placement_preferences.appetite).to eq("not_open")
          expect(placement_preferences.placement_details).to eq(state)
        end
      end

      context "when a step is invalid" do
        let(:state) do
          {
            "appetite" => { "appetite" => "blah" },
            "reason_not_hosting" => {
              "reasons_not_hosting" => [
                "Not enough trained mentors",
                "Number of pupils with SEND needs",
                "Working to improve our OFSTED rating"
              ]
            },
            "school_contact" => {
              "first_name" => "Joe",
              "last_name" => "Bloggs",
              "email_address" => "joe_bloggs@example.com"
            }
          }
        end

        it "returns an error" do
          expect { add_placement_preference }.to raise_error "Invalid wizard state"
        end
      end
    end
  end

  describe "#academic_year" do
    subject(:academic_year) { wizard.academic_year }

    let(:next_academic_year) { AcademicYear.current.next }

    before { next_academic_year }

    it "returns the next academic year" do
      expect(academic_year).to eq(next_academic_year)
    end
  end

  describe "#selected_secondary_subjects" do
    subject(:selected_secondary_subjects) { wizard.selected_secondary_subjects }

    context "when a secondary subject has not been selected" do
      it "returns an empty array" do
        expect(selected_secondary_subjects).to eq([])
      end
    end

    context "when a secondary subject has been selected" do
      let!(:english) { create(:placement_subject, :secondary, name: "English") }
      let!(:mathematics) { create(:placement_subject, :secondary, name: "Mathematics") }
      let(:science) { create(:placement_subject, :secondary, name: "Science") }
      let(:state) do
        {
          "appetite" => { "appetite" => "actively_looking" },
          "phase" => { "phases" => %w[secondary] },
          "secondary_subject_selection" => { "subject_ids" => [ english.id, mathematics.id ] }
        }
      end

      before do
        science
      end

      it "returns a list of selected secondary subjects" do
        expect(selected_secondary_subjects).to contain_exactly(english, mathematics)
      end
    end
  end
end
