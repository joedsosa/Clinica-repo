class PaginationService
  attr_reader :collection, :params

  def initialize(collection, params = {})
    @collection = collection
    @params = params.merge(count: collection.size)
  end

  def metadata
    @metadata ||= generate_metadata
  end

  def execute_query
    collection.limit(items_per_page).offset(paginate_offset).order("#{order_by}": order_direction)
  end

  private

  def generate_metadata
    {
      page: current_page,
      per_page: items_per_page,
      order_by: order_by,
      order_direction: order_direction,
      count: params[:count]
    }
  end

  def default_per_page
    15
  end

  def current_page
    params.fetch(:page, 1).to_i
  end

  def items_per_page
    [
      params.fetch(:per_page, default_per_page).to_i,
      default_per_page
    ].min
  end

  def paginate_offset
    (current_page - 1) * items_per_page
  end

  def order_by
    params.fetch(:order_by, :id)
  end

  def order_direction
    params.fetch(:order_direction, :asc)
  end
end
