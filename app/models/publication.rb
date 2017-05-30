class Publication < ApplicationRecord
  include Paginatable
  belongs_to :company
  

  validates :link, :company_name, presence: true
  validates :head, :annotation, :date_of_publication, presence: true
  validate :company_not_exists
  before_validation :find_company, if: :company_name
 
  def company_name
    super || company&.name
  end

 

  

  def company_not_exists
    errors.add :company_name, :not_exists if company_id.blank?
  end


  def find_company
    self.company_id = Company.find_by(name: company_name)&.id
  end

  
end
