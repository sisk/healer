module XraysHelper

  def xray_preview(xray, options = {})
    render :partial => "xrays/inline_xray_with_nav", :locals => { :xray => xray, :options => options }
  end

end
