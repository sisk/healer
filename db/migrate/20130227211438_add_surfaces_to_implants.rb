class AddSurfacesToImplants < ActiveRecord::Migration
  def change
    add_column :implants, :femur_surface, :string
    add_column :implants, :acetabulum_surface, :string
  end
end
