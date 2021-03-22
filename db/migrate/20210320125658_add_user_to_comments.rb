class AddUserToComments < ActiveRecord::Migration[5.1]
  def change
    add_reference :comments, :user, foreign_key: true
    remove_column :comments, :name, :string
  end
end
