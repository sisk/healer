class SetBilateralRegistrations < ActiveRecord::Migration
  # open and save each registration. This will calculate and set its bilateral boolean
  class Registration < ActiveRecord::Base ; end

  def self.up
    regs = Registration.all
    size = regs.size
    i = 0
    regs.each do |reg|
      i += 1
      puts "Updating registration #{i} of #{size} - ID #{reg.id}..."
      reg.save
    end
  end

  def self.down
    Registration.update_all(:likely_bilateral => false)
  end
end
