class PhotosController < ApplicationController
  # before_action :set_photo, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except:  [:index, :show]
  
  # GET /photos
  # GET /photos.json
  # def index
  #   # @photos = Photo.all

  #   @location = Location.find(params[:location_id])
  #   @photos = @location.photos
  # end

  # GET /photos/1
  # GET /photos/1.json
  # def show
  #   @photo = Photo.find(params[:id])
  # end

  # GET /photos/new
  def new
    @location = Location.find(params[:location_id])
    @photo = @location.photos.new

    # @photo = Photo.new
  end

  # GET /photos/1/edit
  # def edit
  #   @photo = Photo.find(params[:id])
  # end

  # POST /photos
  # POST /photos.json
  def create
    # @photo = Photo.new(photo_params)
    @location = Location.find(params[:location_id])
    @photo = @location.photos.new
    # @photo = @location.photos.new(params.require(:photo).permit(:images))
    # @photo = @location.photos.create(photo_params.merge(user_id: current_user.id))
    # @photo.user_id = current_user.id
    # binding.pry
    # @photo.save
    if params[:images]
      params[:images].inject(true) do |memo, image|
        memo && @location.photos.create(image: image, user_id: current_user.id)
      end
      redirect_to location_path(@location)
    else
      flash.now[:success] = "Please choose one or more images"
      render :new
      # when rendering :new, must redefine @location and @photo
    end

    # if success
    #   redirect_to location_path(@location)
    # else
    #   render :new
    # end
    # if @photo.save
    #   if params[:images]
    #     params[:images].each { |image| 
    #       @location.photos.create(image: image, user_id: current_user.id) }
    #   end

    #   redirect_to session[:my_previous_url]
    # else
    #   render :new
    # end
    # respond_to do |format|
    #   if @photo.save
    #     format.html { redirect_to session[:my_previous_url], notice: 'Photo was successfully created.' }
    #     # format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
    #     format.json { render :show, status: :created, location: @photo }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @photo.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  # def update

  #   @location = Location.find(params[:location_id])

  #   @photo = @location.photos.find(params[:id])

  #   respond_to do |format|
  #     if @photo.update(photo_params)
  #       format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @photo }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @photo.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @location = Location.find(params[:location_id])
    @photo = @location.photos.find(params[:id])

    @photo.destroy
    respond_to do |format|
      format.html { redirect_to location_path(@location) }#, notice: 'Photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      # params[:photo]
      params.require(:photo).permit(:images)
    end
end
