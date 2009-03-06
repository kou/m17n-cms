class Image < ActiveRecord::Base
  acts_as_fleximage :image_directory => IMAGE_DIRECTORY

  def image_filename=(filename)
    self.filename = filename
  end

  def image_width=(width)
    self.width = width
  end

  def image_height=(height)
    self.height = height
  end
end
