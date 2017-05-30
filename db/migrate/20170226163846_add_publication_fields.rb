class AddPublicationFields < ActiveRecord::Migration[5.0]
  def change
  	add_column :publications, :head, :text
    add_column :publications, :annotation, :text
    add_column :publications, :date_of_publication, :date
 
  end
end
