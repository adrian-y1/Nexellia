class AddHasSetPasswordToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :has_set_password, :boolean, default: false
  end
end
