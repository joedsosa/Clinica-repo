class Api::V1::MedicalRecordsController < Api::ApiController
  before_action :set_medical_record, only: %i[show update destroy]

  # GET /api/v1/medical_records
  def index
    @medical_records = MedicalRecord.filter(filter_params).all

    # Paginación
    @pagination, @medical_records = paginate(collection: @medical_records, params: page_params)

    json_response(
      MedicalRecordBlueprinter.render(
        @medical_records,
        view: :normal,
        root: :data,
        meta: { pagination: @pagination }
      )
    )
  end

  # GET /api/v1/medical_records/:id
  def show
    json_response(
      MedicalRecordBlueprinter.render(
        @medical_record,
        root: :data,
        view: :normal
      )
    )
  end

  # POST /api/v1/medical_records
  def create
    @medical_record = MedicalRecord.new(medical_record_params)

    if @medical_record.save
      json_response(
        MedicalRecordBlueprinter.render(
          @medical_record,
          view: :normal
        ),
        status: :created,
        location: api_v1_medical_record_url(@medical_record)
      )
    else
      json_response(@medical_record.errors, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /api/v1/medical_records/:id
  def update
    if @medical_record.update(medical_record_params)
      json_response(
        MedicalRecordBlueprinter.render(
          @medical_record,
          view: :normal
        ),
        status: :ok,
        location: api_v1_medical_record_url(@medical_record)
      )
    else
      json_response(@medical_record.errors, status: :unprocessable_entity)
    end
  end

  # DELETE /api/v1/medical_records/:id
  def destroy
    @medical_record.destroy
    head :no_content
  end

  private

  # Callbacks para encontrar registros
  def set_medical_record
    @medical_record = MedicalRecord.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  # Solo permitir parámetros confiables
  def medical_record_params
    params.require(:medical_record).permit(:doctor_id, :patient_id)
  end

  # Parámetros de paginación
  def page_params
    params.permit(:page, :per_page, :order_direction, :order_by)
  end

  # Filtros básicos
  def filter_params
    params.permit(:doctor_id, :patient_id)
  end
end
