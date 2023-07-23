class UpdateHasSetPasswordForAllUsers < ActiveRecord::Migration[7.0]
  def change
    User.where.not(encrypted_password: nil).update_all(has_set_password: true)
  end
end
