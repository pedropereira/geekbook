class AddProfileUrlToAttendees < ActiveRecord::Migration
  def self.up
    add_column :attendees, :profile_url, :string, :default => nil
  end

  def self.down
    remove_column :attendees, :profile_url
  end
end
