class SwitchPatellaIndication < ActiveRecord::Migration
  def up
    falses = Implant.find_all_by_patella_resurfaced(false)
    trues = Implant.find_all_by_patella_resurfaced(true)
    falses.each{ |i| i.update_attributes(:patella_resurfaced => true) }
    trues.each{ |i| i.update_attributes(:patella_resurfaced => false) }

    rename_column :implants, :patella_resurfaced, :patella_not_resurfaced
  end

  def down
    rename_column :implants, :patella_not_resurfaced, :patella_resurfaced
  end
end