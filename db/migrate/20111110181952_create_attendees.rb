class CreateAttendees < ActiveRecord::Migration
  def self.up
    create_table :attendees do |t|
      t.string :name,           :limit => 64
      t.string :avatar_filename, :limit => 128
    end
  end

  def self.down
    drop_table :attendees
  end
end
