class SchoolsQuery < ApplicationQuery
  MAX_LOCATION_DISTANCE = 50

  def call
    scope = School.left_outer_joins(:placement_preferences)
    scope = schools_to_show_condition(scope)
    scope = search_by_name_condition(scope)
    scope = phase_condition(scope)
    scope = itt_statuses_condition(scope)
    order_condition(scope)
  end

  private

  def search_by_name_condition(scope)
    return scope if filter_params[:search_by_name].blank?

    scope.where("organisations.name ILIKE ?", "%#{filter_params[:search_by_name]}%")
         .or(scope.where("urn ILIKE ?", "%#{filter_params[:search_by_name]}%"))
  end

  def phase_condition(scope)
    return scope if filter_params[:phases].blank?

    scope.where(phase: filter_params[:phases])
  end

  def filter_params
    @filter_params ||= params.fetch(:filters, {})
  end

  def organisation_ids_near_location(location_coordinates)
    Organisation.near(
      location_coordinates,
      MAX_LOCATION_DISTANCE,
      order: :distance,
    ).map(&:id)
  end

  def schools_to_show_condition(scope)
    return scope if filter_params[:schools_to_show] == "all"

    scope.where.associated(:placement_preferences)
  end

  def itt_statuses_condition(scope)
    hosting_interests = filter_params[:itt_statuses]
    return scope if hosting_interests.blank?

    conditions = []

    if hosting_interests.include?("open")
      conditions << scope.where(placement_preferences: { appetite: "interested" })
    end

    if hosting_interests.include?("not_open")
      conditions << scope.where(placement_preferences: { appetite: "not_open" })
    end

    if hosting_interests.include?("actively_looking")
      conditions << scope.where(placement_preferences: { appetite: "actively_looking" })
    end

    conditions.reduce(scope.none) { |combined_scope, condition| combined_scope.or(condition) }
  end

  def order_condition(scope)
    if params[:location_coordinates].present?
      organisation_ids = organisation_ids_near_location(
        params[:location_coordinates],
      )

      sanitised_ids = organisation_ids.map { |id| ActiveRecord::Base.connection.quote(id) }.join(",")
      scope.where(id: organisation_ids)
           .select("organisations.*, array_position(ARRAY[#{sanitised_ids}]::uuid[], organisations.id) AS ordering_index")
           .distinct
           .order(Arel.sql("ordering_index"))
    else
      scope.distinct.order(:name)
    end
  end
end
