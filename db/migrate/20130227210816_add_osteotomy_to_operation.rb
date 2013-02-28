class AddOsteotomyToOperation < ActiveRecord::Migration
  def change
  	add_column :operations, :osteotomy, :string
  end
end
