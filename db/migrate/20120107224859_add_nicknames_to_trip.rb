class AddNicknamesToTrip < ActiveRecord::Migration

  class Trip < ActiveRecord::Base
    def nickname_name
      year = start_date.blank? ? "" : start_date.strftime("%Y")
      Carmen::Country.coded(country).name.downcase + year
    end
  end

  def change
    add_column :trips, :nickname, :string
    add_index :trips, :nickname
    Trip.reset_column_information
    Trip.all.each do |trip|
      trip.update_attribute(:nickname, trip.nickname_name)
    end
  end

end
