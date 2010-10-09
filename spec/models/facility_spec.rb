require 'spec_helper'

describe Facility do
  should_have_column :name, :type => :string
  should_have_column :address1, :type => :string
  should_have_column :address2, :type => :string
  should_have_column :city, :type => :string
  should_have_column :state, :type => :string
  should_have_column :zip, :type => :string
  should_have_column :country, :type => :string

  should_validate_presence_of :name

  should_have_many :operating_rooms
end
