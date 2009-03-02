module DocumentsHelper
  def usage_path
    url_for(:controller => "documents", :action => "usage")
  end

  def usage_for_the_experienced_path
    url_for(:controller => "documents", :action => "experienced")
  end
end
