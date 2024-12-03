class Api::V1::ReviewsController < Api::ApiController
  before_action :set_review, only: %i[show update destroy]

  # GET /api/v1/reviews
  def index
    @reviews = Review.filter(filter_params).all

    # Pagination
    @pagination, @reviews = paginate(collection: @reviews, params: page_params)

    json_response(
      ReviewBlueprinter.render(
        @reviews,
        view: :normal,
        root: :data,
        meta: { pagination: @pagination }
      )
    )
  end

  # GET /api/v1/reviews/:id
  def show
    json_response(
      ReviewBlueprinter.render(
        @review,
        root: :data,
        view: :normal
      )
    )
  end

  # POST /api/v1/reviews
  def create
    @review = Review.new(review_params)

    if @review.save
      json_response(
        ReviewBlueprinter.render(
          @review,
          view: :normal
        ),
        status: :created,
        location: api_v1_review_url(@review)
      )
    else
      json_response(@review.errors, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /api/v1/reviews/:id
  def update
    if @review.update(review_params)
      json_response(
        ReviewBlueprinter.render(
          @review,
          view: :normal
        ),
        status: :ok
      )
    else
      json_response(@review.errors, status: :unprocessable_entity)
    end
  end

  # DELETE /api/v1/reviews/:id
  def destroy
    @review.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_review
    @review = Review.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def review_params
    params.require(:review).permit(
      :email, :first_name, :last_name, :rating, :title, :description
    )
  end

  def page_params
    params.permit(:page, :per_page, :order_direction, :order_by, :count)
  end

  # Filter params
  def filter_params
    params.permit(:rating, :title, :first_name)
  end
end
