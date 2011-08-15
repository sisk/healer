class MirrorBodyPart < ActiveRecord::Migration
  def self.up
    add_column :body_parts, :mirror_id, :integer
    add_index :body_parts, :mirror_id
  end

  def self.down
    remove_index :body_parts, :mirror_id
    remove_column :body_parts, :mirror_id
  end
end