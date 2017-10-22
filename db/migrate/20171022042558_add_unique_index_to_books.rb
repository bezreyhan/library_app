class AddUniqueIndexToBooks < ActiveRecord::Migration[5.1]
  def change
    add_index :books, [:author, :title], unique: true
  end
end
