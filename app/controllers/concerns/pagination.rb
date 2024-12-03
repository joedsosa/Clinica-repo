module Pagination
  extend ActiveSupport::Concern
  def paginate(collection:, params: {})
    pagination = PaginationService.new(collection, params)

    [
      pagination.metadata,
      pagination.execute_query
    ]
  end
end
