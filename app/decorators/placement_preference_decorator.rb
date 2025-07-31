class PlacementPreferenceDecorator < ApplicationDecorator
  delegate_all

  def secondary_subject_name(subject_id:)
    subject = PlacementSubject.find(subject_id)
    return subject.name unless subject.has_child_subjects?

    child_subject_ids = placement_details.dig(
      "secondary_child_subject_selection_#{subject_id}",
      "child_subject_ids",
    )

    child_subjects = PlacementSubject
      .where(id: child_subject_ids)
      .order_by_name

    "#{subject.name} - #{child_subjects.pluck(:name).to_sentence}"
  end
end
