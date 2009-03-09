class SitesController < ApplicationController
  # GET /sites
  # GET /sites.xml
  def index
    redirect_to(Site.default)
  end

  # GET /sites/1
  # GET /sites/1.xml
  def show
    @site = Site.find(params[:id])
    if @site.blank_configuration?
      redirect_to(edit_site_path(@site))
      return
    end

    @ftp = Ftp.new(params[:ftp])
    @ftp_upload_status_message = nil

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @site }
    end
  end

  # GET /sites/new
  # GET /sites/new.xml
  def new
    @site = Site.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @site }
    end
  end

  # GET /sites/1/edit
  def edit
    @site = Site.find(params[:id])
  end

  # POST /sites
  # POST /sites.xml
  def create
    @site = Site.new(params[:site])

    respond_to do |format|
      if @site.save
        flash[:notice] = 'Site was successfully created.'
        format.html { redirect_to(@site) }
        format.xml  { render :xml => @site, :status => :created, :location => @site }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.xml
  def update
    @site = Site.find(params[:id])

    respond_to do |format|
      if @site.update_attributes(params[:site])
        flash[:notice] = 'Site was successfully updated.'
        format.html { redirect_to(@site) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.xml
  def destroy
    @site = Site.find(params[:id])
    @site.destroy

    respond_to do |format|
      format.html { redirect_to(sites_url) }
      format.xml  { head :ok }
    end
  end

  def upload
    @site = Site.find(params[:id])
    @ftp = Ftp.new(params[:ftp])
    @ftp_upload_status_message = t("Start")

    fork do
      STDIN.reopen("/dev/null")
      STDOUT.reopen(upload_status_file, "w")
      STDERR.reopen("/dev/null", "w")
      ENV["M17N_CMS_LOCALE"] = I18n.locale.to_s
      ENV["M17N_CMS_VERBOSE"] = "true"
      ENV["M17N_CMS_FTP_USER"] = @ftp.user
      ENV["M17N_CMS_FTP_PASSWORD"] = @ftp.password
      Dir.chdir(RAILS_ROOT) do
        system("rake", "-s", "ftp:upload")
      end
      STDOUT.reopen("/dev/null", "w")
      sleep(2)
      FileUtils.rm_f(upload_status_file)
      exit!(0)
    end
    render(:action => :show)
  end

  def upload_status
    if File.exist?(upload_status_file)
      @status = File.read(upload_status_file)
      render(:layout => false)
    else
      head(:not_found)
    end
  end

  private
  def upload_status_file
    status = File.join(RAILS_ROOT, "tmp", "ftp-upload-status")
  end
end
