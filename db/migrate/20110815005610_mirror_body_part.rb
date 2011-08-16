class MirrorBodyPart < ActiveRecord::Migration

  class BodyPart < ActiveRecord::Base
    @@all_body_parts ||= all
    belongs_to :mirror, :class_name => "BodyPart", :foreign_key => "mirror_id"
    def old_mirror
      all_body_parts.select{ |bp| (bp.name_en == name_en && bp.side != side) }.first
    end
  private
    def all_body_parts
      @@all_body_parts
    end
  end

  def self.up
    add_column :body_parts, :mirror_id, :integer
    add_index :body_parts, :mirror_id
    
    BodyPart.reset_column_information
    
    BodyPart.all.each do |body_part|
      body_part.update_attributes(:mirror => body_part.old_mirror)
    end
    
  end

  def self.down
    remove_index :body_parts, :mirror_id
    remove_column :body_parts, :mirror_id
  end
end