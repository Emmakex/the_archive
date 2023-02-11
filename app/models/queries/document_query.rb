class Queries::DocumentQuery
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :tag, :string
  attribute :location, :integer

  def fetch(page: 1, per_page: 10)
    documents = Document.preload(:location, :tags)

    if tag.present?
      documents = documents
                  .joins(:tags)
                  .where(tags: { name: tag })
    end

    if location.present?
      documents = documents
                  .where(location:)
    end

    Queries::Page.new(documents, page:, per_page:)
  end
end
