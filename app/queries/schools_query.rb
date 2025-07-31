class SchoolsQuery < ApplicationQuery
  MAX_LOCATION_DISTANCE = 50

  def call
    scope = School
    scope = search_by_name_condition(scope)
    scope = phase_condition(scope)
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
