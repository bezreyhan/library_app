class CreateBookOwnerships < ActiveRecord::Migration[5.1]
  def change
    create_table :book_ownerships do |t|
      t.references :user, foreign_key: true
      t.references :book, foreign_key: true
      t.boolean :read

      t.timestamps
    end
    add_index :book_ownerships, [:user_id, :book_id], unique: true
  end
end
