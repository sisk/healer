class BodyPart < ActiveRecord::Base; end

class PatientCase < ActiveRecord::Base
  belongs_to :body_part
end

class RemoveBodyPartModel < ActiveRecord::Migration
  def up
    require "body_part_migrator"
    BodyPartMigrator.new.perform

    remove_column :diagnoses, :body_part_id
    remove_column :implants, :body_part_id
    remove_column :patient_cases, :body_part_id

    drop_table :body_parts
  end

  def down
    create_table "body_parts", :force => true do |t|
      t.string   "name_en",    :null => false
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.string   "side"
      t.string   "name_es"
      t.integer  "mirror_id"
    end

    add_index "body_parts", ["mirror_id"], :name => "index_body_parts_on_mirror_id"
 
    add_column :diagnoses, :body_part_id, :integer
    add_column :implants, :body_part_id, :integer
    add_column :patient_cases, :body_part_id, :integer 
  end
end
