# -*- ruby -*-

namespace :ftp do
  desc "Upload static HTML"
  task :upload => "static:generate" do
    FtpUploader.new.upload
  end
end
