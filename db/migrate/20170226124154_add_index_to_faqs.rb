class AddIndexToFaqs < ActiveRecord::Migration[5.0]
  def change
    add_index :faqs, :position
  end
end
