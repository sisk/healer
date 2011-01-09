module RegistrationsHelper
  
  def body_part_list(registration)
    if registration.likely_bilateral?
      body_parts = registration.diagnoses.map(&:body_part)
      body_part_names = body_parts.map(&:name)
      # part_counts = body_parts.map(&:name).inject(Hash.new(0)) {|h,x| h[x]+=1;h}
      p = []
      body_parts.each do |body_part|
        if body_part_names.count(body_part.name) > 1
          p << body_part.name + " (Bilateral)"
        else
          p << body_part.to_s
        end
      end
      return p.uniq.join(", ")
    else
      registration.diagnoses.map(&:body_part).map(&:to_s).join(", ")
    end
  end
  
end
