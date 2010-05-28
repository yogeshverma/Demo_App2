class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends do |t|
      t.integer :user_id

      t.timestamps
    end
    add_index :friends, :user_id

  end

  def self.down
    drop_table :friends
  end
end
