class LocationsController < ApplicationController
  # before_action :set_location, only: [:show, :edit, :update, :destroy] #remove repetition
  after_filter 'save_my_previous_url', only: [:new, :edit]
  before_filter :authenticate_user!, except:  [:index, :show] #devise method to require login for new

  def save_my_previous_url
    session[:my_previous_url] = URI(request.referer || '').path
  end

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.all
  end
  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])
    @photos = @location.photos
  end

  # GET /locations/new
  def new
    # @location = Location.new
    @location = current_user.locations.new #passes in user_id attribute / creates location under current user
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
    # @location = current_user.locations.find(params[:id])
  end

  # POST /locations
  # POST /locations.json
  def create
    # @location = Location.new(location_params)
    @location = current_user.locations.create(location_params)

    respond_to do |format|
      if @location.save

        if params[:images]
          # The magic is here ;)
          params[:images].each { |image|
            @location.photos.create(image: image)
          }
        end

        # format.html { redirect_to locations_path, notice: 'Location was successfully created.' }
        format.html { redirect_to session[:my_previous_url], notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    @location = Location.find(params[:id])
    # @location = current_user.locations.find(params[:id])


    respond_to do |format|
      if @location.update(location_params)
        if params[:images]
          # The magic is here ;)
          params[:images].each { |image|
            @location.photos.create(image: image, user_id: current_user.id)
          }
        end

        # format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.html { redirect_to session[:my_previous_url] }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    # @location = Location.find(params[:id])
    @location = current_user.locations.find(params[:id])
    
    @location.destroy
    
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit( :name,
                                        :photos,
                                        :longitude,
                                        :latitude,
                                        :equipment)
    end

end