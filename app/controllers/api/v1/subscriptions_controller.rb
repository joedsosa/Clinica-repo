class Api::V1::SubscriptionsController < Api::ApiController
  before_action :set_subscription, only: %i[show update destroy]

  # GET /api/v1/subscriptions
  def index
    @subscriptions = Subscription.filter(filter_params).all

    # Pagination
    @pagination, @subscriptions = paginate(collection: @subscriptions, params: page_params)

    json_response(
      SubscriptionBlueprinter.render(
        @subscriptions,
        view: :normal,
        root: :data,
        meta: { pagination: @pagination }
      )
    )
  end

  # GET /api/v1/subscriptions/:id
  def show
    json_response(
      SubscriptionBlueprinter.render(
        @subscription,
        root: :data,
        view: :normal
      )
    )
  end

  # POST /api/v1/subscriptions
  def create
    @subscription = Subscription.new(subscription_params)

    if @subscription.save
      json_response(
        SubscriptionBlueprinter.render(
          @subscription,
          view: :normal
        ),
        status: :created,
        location: api_v1_subscription_url(@subscription)
      )
    else
      json_response(@subscription.errors, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /api/v1/subscriptions/:id
  def update
    if @subscription.update(subscription_params)
      json_response(
        SubscriptionBlueprinter.render(
          @subscription,
          view: :normal
        ),
        status: :ok
      )
    else
      json_response(@subscription.errors, status: :unprocessable_entity)
    end
  end

  # DELETE /api/v1/subscriptions/:id
  def destroy
    @subscription.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def subscription_params
    params.require(:subscription).permit(
      :email, :first_name, :last_name, :terms_and_conditions
    )
  end

  def page_params
    params.permit(:page, :per_page, :order_direction, :order_by, :count)
  end

  # Filter params
  def filter_params
    params.permit(:email, :first_name, :last_name)
  end
end
