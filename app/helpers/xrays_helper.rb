module XraysHelper
  
  def xray_thumbnail(xray, options = {})
    render :partial => "xrays/inline_xray_with_nav", :locals => { :xray => xray }
  end
  
end
