class CreateRetweets < ActiveRecord::Migration[7.0]
  def change
    create_table :retweets do |t|
      t.references :user
      t.references :tweet
      t.timestamps
    end
    add_foreign_key :retweets, :users
    add_foreign_key :retweets, :tweets
  end
end
