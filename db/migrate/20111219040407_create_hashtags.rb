class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.string :tag

      t.timestamps
    end
    add_index :hashtags, :tag, :unique => true    
  end
end
