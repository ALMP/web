class AddTermsOfUseConfirmToReview < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :terms_of_use_confirmed, :boolean, default: false
  end
end
