class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :id_str
      t.string :text
      t.string :username
      t.integer :retweet_count, :default => 0

      t.timestamps
    end
    add_index :tweets, :id_str, :unique => true
    add_index :tweets, :username
  end
end
