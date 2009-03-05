# -*- ruby -*-

namespace :static do
  desc "Generate static HTML"
  task :generate => :environment do
    StaticGenerator.new.generate
  end
end
