# Call scopes directly from your URL params:
#
#     @products = Product.filter(params.slice(:status, :location, :starts_with))
# For Dynamic Columns Filter
#     errors, productive_kpi = ProductiveCoreField
#       .filter_by_dynamic_columns(dynamic_params, active_record_association, @metric)
module Filterable
  extend ActiveSupport::Concern

  class_methods do
    # to enable this scope in your class, just call this methid within your model
    def make_dynamic_column_filterable
      # Scopes
      scope :filter_by_subcategories, lambda { |value, column_name|
        where(
          dynamic_table_cells: {
            value: value,
            dynamic_table_columns: { name: column_name }
          }
        )
      }
    end
  end

  module ClassMethods
    # Call the class methods with names based on the keys in <tt>filtering_params</tt>
    # with their associated values. For example, "{ status: 'delayed' }" would call
    # `filter_by_status('delayed')`. Most useful for calling named scopes from
    # URL params. Make sure you don't pass stuff directly from the web without
    # whitelisting only the params you care about first!
    def filter(filtering_params, options = {})
      results = options[:relation] || where(nil)
      results = results.includes(options[:includes])
      filtering_params.each do |key, value|
        results = results.public_send("filter_by_#{key}", value) if value.present?
      end
      results
    end
  end
end
