class RemoveFirstAndLastNameFromProfiles < ActiveRecord::Migration[7.0]
  def change
    remove_column :profiles, :first_name
    remove_column :profiles, :last_name
  end
end
