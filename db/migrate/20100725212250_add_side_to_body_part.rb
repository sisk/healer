class AddSideToBodyPart < ActiveRecord::Migration
  def self.up
    add_column :body_parts, :side, :string
  end

  def self.down
    remove_column :body_parts, :side
  end
end
