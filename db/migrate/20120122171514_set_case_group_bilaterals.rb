class SetCaseGroupBilaterals < ActiveRecord::Migration

  class CaseGroup < ActiveRecord::Base

    has_many :patient_cases

    def bilateral?
      patient_cases.size > 1 && patient_cases.any?{ |pc| pc.bilateral_case.present? }
    end

    def join_bilateral_cases
      return if bilateral?
      # TODO this seems way too hacky. Reeking of poor design. Make it better.
      patient_cases.group_by{ |pc| pc.body_part.try(:name_en) }.each do |body_part_name, cases|
        if cases.size == 2
          # Very likely this is a bilateral scenario. Set each to the other's bilateral.
          cases[0].update_attribute(:bilateral_case_id, cases[1].id)
          cases[1].update_attribute(:bilateral_case_id, cases[0].id)
        end
      end
    end

  end

  def up
    CaseGroup.all.each do |case_group|
      case_group.join_bilateral_cases
    end
  end

  def down
  end

end
