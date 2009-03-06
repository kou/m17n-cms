if RAILS_ENV == "test"
  IMAGE_DIRECTORY = File.join("tmp", "images", "uploaded")
else
  IMAGE_DIRECTORY = File.join("public", "images", "uploaded")
end
