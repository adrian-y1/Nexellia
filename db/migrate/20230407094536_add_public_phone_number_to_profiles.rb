class AddPublicPhoneNumberToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :public_phone_number, :string
  end
end
