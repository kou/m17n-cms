# -*- ruby -*-

namespace :static do
  desc "Generate static HTML"
  task :generate => :environment do
    output_dir = StaticGenerator.output_dir
    StaticGenerator.new(output_dir).generate
  end
end
