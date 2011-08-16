class AttachBilateralToCase < ActiveRecord::Migration

  class Patient < ActiveRecord::Base
    has_many :patient_cases, :dependent => :destroy
    has_many :diagnoses, :through => :patient_cases
  end
  
  class PatientCase < ActiveRecord::Base
    has_many :diagnoses
    has_many :operations
    belongs_to :patient
    def bilateral_diagnosis?
      return false if diagnoses.empty?
      return diagnoses.any?{ |diagnosis| diagnosis.has_mirror? }
    end
  end
  
  class Diagnosis < ActiveRecord::Base
    belongs_to :body_part
    belongs_to :patient_case
    has_one :operation
    def has_mirror?
      return false if !body_part.present? || siblings.empty? || !body_part.mirror.present?
      return mirrors.size > 0
    end
    def mirrors
      siblings.select{ |diagnosis| body_part.mirror_id == diagnosis.body_part_id }
    end
    def siblings
      return [] unless patient_case.present?
      patient_case.diagnoses - [self]
    end
  end
  
  class BodyPart < ActiveRecord::Base
    @@all_body_parts ||= all
    belongs_to :mirror, :class_name => "BodyPart", :foreign_key => "mirror_id"
  private
    def all_body_parts
      @@all_body_parts
    end
  end

  class Operation < ActiveRecord::Base
    belongs_to :patient
    belongs_to :diagnosis
    belongs_to :body_part
    belongs_to :patient_case
  end
  
  def self.up
    add_column :patient_cases, :bilateral_case_id, :integer
    add_index :patient_cases, :bilateral_case_id
    
    PatientCase.reset_column_information
    
    PatientCase.all.each do |patient_case|
      if patient_case.bilateral_diagnosis?

        # We need to create a new case for each bilateral "case", and hard-link the new object to its operation and diagnosis
        diagnosis1 = patient_case.diagnoses[0]
        diagnosis2 = patient_case.diagnoses[1]

        op1 = patient_case.operations.detect{ |op| op.body_part_id == diagnosis1.body_part_id }
        op2 = patient_case.operations.detect{ |op| op.body_part_id == diagnosis2.body_part_id }

        puts "Cloning Case ID #{patient_case.id}..."
        new_case = PatientCase.create(patient_case.attributes.reject{ |k,v| k.to_sym == :id }.merge(:bilateral_case_id => patient_case.id))
        patient_case.update_attributes(:bilateral_case_id => new_case.id)

        diagnosis2.update_attributes(:patient_case => new_case) if diagnosis2
        op2.update_attributes(:patient_case => new_case) if op2
      end
    end
    
  end

  def self.down
    remove_index :patient_cases, :bilateral_case_id
    remove_column :patient_cases, :bilateral_case_id
  end
end