class API::GoogleController < ApplicationController
  def map_key
    map_key = ENV.fetch("GOOGLE_MAPS_API_KEY", "")
    render json: { map_key: }
  rescue KeyError
    render json: { error: "Google Maps API key not configured" }, status: :internal_server_error
  end
end
