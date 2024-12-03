class Api::V1::MedicinesController < Api::ApiController
  before_action :set_medicine, only: %i[show update destroy]

  # GET api/v1/medicines
  def index
    @medicines = Medicine.filter(filter_params).all

    # Paginación
    @pagination, @medicines = paginate(collection: @medicines, params: page_params)

    json_response(
      MedicineBlueprinter.render(
        @medicines,
        view: :normal,
        root: :data,
        meta: { pagination: @pagination }
      )
    )
  end

  # GET api/v1/medicines/:id
  def show
    json_response(
      MedicineBlueprinter.render(
        @medicine,
        root: :data,
        view: :normal
      )
    )
  end

  # POST api/v1/medicines
  def create
    @medicine = Medicine.new(medicine_params)

    if @medicine.save
      json_response(
        MedicineBlueprinter.render(
          @medicine,
          view: :normal
        ),
        status: :created,
        location: api_v1_medicine_url(@medicine)
      )
    else
      error_messages = @medicine.errors
      json_response(error_messages, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT api/v1/medicines/:id
  def update
    if @medicine.update(medicine_params)
      json_response(
        MedicineBlueprinter.render(
          @medicine,
          view: :normal
        ),
        status: :ok
      )
    else
      error_messages = @medicine.errors
      json_response(error_messages, status: :unprocessable_entity)
    end
  end

  # DELETE api/v1/medicines/:id
  def destroy
    @medicine.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_medicine
    @medicine = Medicine.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def medicine_params
    params.require(:medicine).permit(
      :name, :description, :dosage, :dosage_form, :instructions
    )
  end

  def page_params
    params.permit(:page, :per_page, :order_direction, :order_by, :count)
  end

  # Filter params
  def filter_params
    params.permit(:name)
  end
end
