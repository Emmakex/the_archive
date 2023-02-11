class Document < ApplicationRecord
  belongs_to :location
  belongs_to :created_by, class_name: 'User'
  has_and_belongs_to_many :tags
  has_one_attached :attachment

  def self.next_identifier(prefix)
    last_identifier = Document.where('identifier LIKE ?', "#{prefix}-%").maximum(:identifier)
    last_identifier.next
  end
end
