# Form object to deal with document creation.
class DocumentCreationForm
  include ActiveModel::API
  include ActiveModel::Attributes

  def self.model_name = ActiveModel::Name.new(self, nil, 'Document')

  attribute :id, :integer
  attribute :title, :string
  attribute :description, :string
  attribute :date, :date
  attribute :identifier, :string
  attribute :location, :string
  attribute :tags, :string

  attribute :attachment

  def save
    record = Document.transaction do
      location_record = Location.find_or_create_by!(name: location)
      tag_records = tags.split(',').map { Tag.find_or_create_by!(name: _1.strip) }
      record_attributes = { id:, title:, description:, date:, attachment: }

      identifier_prefix = location_record.name.underscore
      identifier_with_prefix =
        if identifier.present?
          identifier.starts_with?(identifier_prefix) ? identifier : "#{identifier_prefix}-#{identifier}"
        else
          Document.next_identifier(identifier_prefix)
        end

      Document.create!(location: location_record,
                       tags: tag_records,
                       created_by: Current.user,
                       identifier: identifier_with_prefix,
                       **record_attributes)
    end

    self.id = record.id
  end
end
