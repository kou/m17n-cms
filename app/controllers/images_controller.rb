class ImagesController < ApplicationController
  # GET /images
  # GET /images.xml
  def index
    @images = Image.find(:all)
    @image = Image.new(params[:image])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @images }
    end
  end

  # GET /images/1
  # GET /images/1.xml
  def show
    @image = Image.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @image }
      format.png
      format.jpg
      format.gif
    end
  end

  def thumbnail
    @image = Image.find(params[:id])

    respond_to do |format|
      format.png
      format.jpg
      format.gif
    end
  end

  # POST /images
  # POST /images.xml
  def create
    @image = Image.new(params[:image])

    respond_to do |format|
      if @image.save
        flash[:notice] = t('Image was successfully uploaded.')
        format.html { redirect_to(formatted_image_path(@image, :html)) }
        format.xml  { render :xml => @image, :status => :created, :location => @image }
      else
        format.html do
          @images = Image.find(:all)
          render :action => "index"
        end
        format.xml  { render :xml => @image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.xml
  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to(images_url) }
      format.xml  { head :ok }
    end
  end
end
