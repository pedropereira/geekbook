class AddGeekVotesToAttendees < ActiveRecord::Migration
  def self.up
    add_column :attendees, :geek_votes, :integer, :default => 0
  end

  def self.down
    remove_column :attendees, :geek_votes
  end
end
