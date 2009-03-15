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
        flash[:notice] = t('Site was successfully created.')
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
        flash[:notice] = t('Site was successfully updated.')
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

    FileUtils.rm_f(upload_status_files)
    fork do
      STDIN.reopen("/dev/null")
      STDOUT.reopen(upload_progress_file, "w")
      STDERR.reopen("/dev/null", "w")
      puts(t("Start"))
      ENV["M17N_CMS_LOCALE"] = I18n.locale.to_s
      ENV["M17N_CMS_VERBOSE"] = "true"
      ENV["M17N_CMS_FTP_USER"] = @ftp.user
      ENV["M17N_CMS_FTP_PASSWORD"] = @ftp.password
      success = false
      Dir.chdir(RAILS_ROOT) do
        success = system("rake -s ftp:upload 2>&1")
      end
      STDOUT.reopen("/dev/null", "w")
      if success
        FileUtils.touch(upload_success_file)
      else
        FileUtils.touch(upload_failure_file)
      end
      exit!(0)
    end
    render(:action => :show)
  end

  def upload_status
    @status = ""
    if File.exist?(upload_progress_file)
      @status << File.read(upload_progress_file)
    end
    if File.exist?(upload_success_file)
      @status << t("Success")
      FileUtils.rm_f(upload_status_files)
    elsif File.exist?(upload_failure_file)
      @status << t("Failure")
      FileUtils.rm_f(upload_status_files)
    end

    if @status.blank?
      head(:not_found)
    else
      render(:layout => false)
    end
  end

  private
  def upload_status_path(name)
    File.join(RAILS_ROOT, "tmp", "ftp-upload-#{name}")
  end

  def upload_status_files
    [upload_progress_file, upload_success_file, upload_failure_file]
  end

  def upload_progress_file
    upload_status_path("progress")
  end

  def upload_success_file
    upload_status_path("success")
  end

  def upload_failure_file
    upload_status_path("failure")
  end
end
