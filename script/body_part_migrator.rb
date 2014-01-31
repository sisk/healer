#encoding: UTF-8
require File.expand_path('../../config/environment',  __FILE__)

class PatientCase < ActiveRecord::Base
  belongs_to :body_part
end
class BodyPart < ActiveRecord::Base; end

class BodyPartMigrator

  def perform
    PatientCase.all.each do |p_case|
      body_part = p_case.body_part
      if body_part
        p_case.anatomy ||= body_part.name_en.downcase
        p_case.side ||= side_for(body_part)
        p_case.save!
      end
    end
  end

  private ######################################################################


  def side_for(body_part)
    side = body_part.side
    return nil unless side.present?
    side == "L" ? "left" : "right"
  end

end