class BackfillNameFullOnPatient < ActiveRecord::Migration
  def up
    Patient.all.each{ |p| p.update_column(:name_full, p.name) }
  end

  def down
    Patient.all.each{ |p| p.update_column(:name_full, nil) }
  end
end
