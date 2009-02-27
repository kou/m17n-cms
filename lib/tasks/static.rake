# -*- ruby -*-

namespace :static do
  desc "Generate static HTML"
  task :generate => :environment do
    output_dir = ENV["M17N_CMS_OUTPUT_DIR"]
    output_dir ||= File.join(RAILS_ROOT, "public", "static")
    StaticGenerator.new(output_dir).generate
  end
end
