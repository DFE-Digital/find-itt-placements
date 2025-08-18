class OrganisationsController < ApplicationController
  before_action :store_filter_params, only: %i[index]

  helper_method :location_coordinates

  def show
    @organisation = Organisation.find(params[:id])
    if @organisation.is_a?(School)
      @organisation = @organisation.decorate
      @placement_preference = @organisation
        .placement_preference_for(academic_year: AcademicYear.next)
        .decorate
      @placement_details = @placement_preference.placement_details
    end

    render locals: {
      organisation: @organisation,
      placement_preference: @placement_preference,
      placement_details: @placement_details
    }
  end

  def index
    schools = SchoolsQuery.call(params: query_params)
    @pagy, @schools = pagy(schools)
    @schools = @schools.decorate
    calculate_travel_time

    render locals: { pagy: @pagy, schools: @schools, filter_form: }
  end

  private

  def filter_form
    @filter_form = Organisations::FilterForm.new(filter_params)
  end

  def search_location
    @search_location ||= params[:search_location] || params.dig(:filters, :search_location)
  end

  def location_coordinates
    return if search_location.blank?

    @location_coordinates ||= Geocoder::Search.call(search_location).coordinates
  end

  def filter_params
    params.fetch(:filters, {}).permit(
      :search_location,
      :search_by_name,
      :schools_to_show,
      itt_statuses: [],
      phases: [],
      subject_ids: [],
      )
  end

  def query_params
    {
      filters: filter_form.query_params,
      location_coordinates: location_coordinates
    }
  end

  def calculate_travel_time
    return if search_location.blank?

    TravelTime.call(
      origin_address: search_location,
      destinations: @schools.uniq,
    )
  end

  def store_filter_params
    session["find_filter_params"] = { filters: filter_params, page: params[:page] }
  end
end
