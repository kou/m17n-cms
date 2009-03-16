# -*- ruby -*-

namespace :static do
  desc "Generate static HTML"
  task :generate => :environment do
    StaticGenerator.new.generate
  end

  desc "Generate static document HTML"
  task :documents => :environment do
    StaticDocumentGenerator.new.generate
  end
end
