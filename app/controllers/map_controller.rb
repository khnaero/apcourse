class MapController < ApplicationController
  def index
  	@locations = Location.order(:name)

    @geojson = Array.new

    @locations.each do |location|
      @geojson << {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [location.longitude, location.latitude]
        },
        properties: {
          name: location.name,
          equipment: location.equipment,
          # :'marker-color' => '#00607d',
          # :'marker-symbol' => 'circle',
          # :'marker-size' => 'medium'
        }
      }
    end

    respond_to do |format|
      format.html
      format.json { render json: @geojson }
    end
  end
end
