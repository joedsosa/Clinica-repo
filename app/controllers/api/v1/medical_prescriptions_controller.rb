class Api::V1::MedicalPrescriptionsController < Api::ApiController
  before_action :set_medical_prescription, only: %i[show update destroy]

  # GET /api/v1/medical_prescriptions
  def index
    @medical_prescriptions = MedicalPrescription.all

    # Aplicar filtros si están presentes en los parámetros
    @medical_prescriptions = @medical_prescriptions.filter_by_medication_name(filter_params[:medication_name]) if filter_params[:medication_name].present?
    @medical_prescriptions = @medical_prescriptions.filter_by_start_date(filter_params[:start_date]) if filter_params[:start_date].present?
    @medical_prescriptions = @medical_prescriptions.filter_by_end_date(filter_params[:end_date]) if filter_params[:end_date].present?

    # Pagination
    @pagination, @medical_prescriptions = paginate(collection: @medical_prescriptions, params: page_params)

    json_response(
      MedicalPrescriptionBlueprinter.render(
        @medical_prescriptions,
        view: :normal,
        root: :data,
        meta: { pagination: @pagination }
      )
    )
  end

  # GET /api/v1/medical_prescriptions/:id
  def show
    json_response(
      MedicalPrescriptionBlueprinter.render(
        @medical_prescription,
        root: :data,
        view: :normal
      )
    )
  end

  # POST /api/v1/medical_prescriptions
  def create
    @medical_prescription = MedicalPrescription.new(medical_prescription_params)

    if @medical_prescription.save
      json_response(
        MedicalPrescriptionBlueprinter.render(
          @medical_prescription,
          view: :normal
        ),
        status: :created,
        location: api_v1_medical_prescription_url(@medical_prescription)
      )
    else
      json_response(@medical_prescription.errors, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /api/v1/medical_prescriptions/:id
  def update
    if @medical_prescription.update(medical_prescription_params)
      json_response(
        MedicalPrescriptionBlueprinter.render(
          @medical_prescription,
          view: :normal
        ),
        status: :ok
      )
    else
      json_response(@medical_prescription.errors, status: :unprocessable_entity)
    end
  end

  # DELETE /api/v1/medical_prescriptions/:id
  def destroy
    @medical_prescription.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_medical_prescription
    @medical_prescription = MedicalPrescription.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def medical_prescription_params
    params.require(:medical_prescription).permit(
      :medication_name, :dosage, :frequency, :instructions, :start_date, :end_date, :doctor_id, :patient_id
    )
  end

  def page_params
    params.permit(:page, :per_page, :order_direction, :order_by, :count)
  end

  # Filter params
  def filter_params
    params.permit(:medication_name, :start_date, :end_date, :doctor_id, :patient_id)
  end
end
