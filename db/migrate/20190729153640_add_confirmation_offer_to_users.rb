class AddConfirmationOfferToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :confirmation_offer, :boolean, default: false
  end
end
