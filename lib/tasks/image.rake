# -*- ruby -*-

rule ".png" => [".svg"] do |t|
  sh("inkscape",
     "--export-png", t.name,
     t.source)
end

namespace :image do
  svgs = Dir[File.join(RAILS_ROOT, "public", "images",
                       "{documents,tiny_mce}", "*.svg")]
  generated_images = svgs.collect do |svg|
    svg.gsub(/\.svg\z/, ".png")
  end

  desc "Generate images"
  task :generate => generated_images

  desc "Clean generated images"
  task :clean do
    rm_f(generated_images)
  end
end
