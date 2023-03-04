class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.text :body
      t.integer :author_id

      t.timestamps
    end
  end
end
