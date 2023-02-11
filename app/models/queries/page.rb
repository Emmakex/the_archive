class Queries::Page
  attr_reader :next_page, :previous_page, :records

  def initialize(query, page:, per_page:)
    offset = (page - 1) * per_page
    limit = per_page + 1
    records = query.offset(offset).limit(limit)
    @next_page = page + 1 if records.size > per_page
    @previous_page = page - 1 if page > 1
    @records = records.first(per_page)
  end
end
