require 'net/ftp'
require 'pathname'

class FtpUploader
  include TaskLogger
  include I18n

  def initialize
  end

  def upload
    static_html_dir = Pathname(StaticGenerator.output_dir)
    site = Site.default
    ftp_user = ENV["M17N_CMS_FTP_USER"]
    ftp_password = ENV["M17N_CMS_FTP_PASSWORD"]

    log(t("Logging into FTP server..."))
    Net::FTP.open(site.ftp_host, ftp_user, ftp_password) do |ftp|
      log(t("Removing old contents..."))
      rm_rf(ftp, site.ftp_path)

      ftp.mkdir(site.ftp_path)
      ftp.chdir(site.ftp_path)

      log(t("Putting static HTML..."))
      static_html_dir.find do |path|
        relative_path = path.relative_path_from(static_html_dir)
        next if relative_path.to_s == "."
        Find.prune if relative_path.basename.to_s == ".svn"
        if path.directory?
          ftp.mkdir(relative_path.to_s)
        else
          ftp.putbinaryfile(path.to_s, relative_path.to_s)
        end
      end
    end
    log(t("Finished to upload"))
  end

  private
  def rm_rf(ftp, path)
    begin
      ftp.list(path)
    rescue Net::FTPError
      return
    end

    begin
      ftp.delete(path)
    rescue Net::FTPError
      ftp.chdir(path)
      ftp.nlst.each do |name|
        next if name == "." or name == ".."
        rm_rf(ftp, name)
      end
      ftp.chdir("..")
      ftp.rmdir(path)
    end
  end
end
