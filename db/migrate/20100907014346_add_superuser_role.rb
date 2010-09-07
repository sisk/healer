class AddSuperuserRole < ActiveRecord::Migration
  def self.up
    Role.create(:name => "superuser")
  end

  def self.down
    Role.find_by_name("superuser").destroy
  end
end
