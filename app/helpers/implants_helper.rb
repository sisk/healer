module ImplantsHelper
  
  def output_type(implant)
    implant.type.try(:underscore) || "unspecified"
  end
  
end
