class Api::V1::DiagnosesController < Api::ApiController
  before_action :set_diagnosis, only: %i[show update destroy]

  # GET /api/v1/diagnoses
  def index
    @diagnoses = Diagnosis.filter(filter_params).all

    # Paginación
    @pagination, @diagnoses = paginate(collection: @diagnoses, params: page_params)

    json_response(
      DiagnosisBlueprinter.render(
        @diagnoses,
        view: :normal,
        root: :data,
        meta: { pagination: @pagination }
      )
    )
  end

  # GET /api/v1/diagnoses/:id
  def show
    json_response(
      DiagnosisBlueprinter.render(
        @diagnosis,
        root: :data,
        view: :normal
      )
    )
  end

  # POST /api/v1/diagnoses
  def create
    @diagnosis = Diagnosis.new(diagnosis_params)

    if @diagnosis.save
      json_response(
        DiagnosisBlueprinter.render(
          @diagnosis,
          view: :normal
        ),
        status: :created,
        location: api_v1_diagnosis_url(@diagnosis)
      )
    else
      json_response(@diagnosis.errors, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /api/v1/diagnoses/:id
  def update
    if @diagnosis.update(diagnosis_params)
      json_response(
        DiagnosisBlueprinter.render(
          @diagnosis,
          view: :normal
        ),
        status: :ok,
        location: api_v1_diagnosis_url(@diagnosis)
      )
    else
      json_response(@diagnosis.errors, status: :unprocessable_entity)
    end
  end

  # DELETE /api/v1/diagnoses/:id
  def destroy
    @diagnosis.destroy
    head :no_content
  end

  private

  # Callbacks para encontrar diagnóstico
  def set_diagnosis
    @diagnosis = Diagnosis.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  # Solo permitir parámetros confiables
  def diagnosis_params
    params.require(:diagnosis).permit(:description, :doctor_id, :patient_id)
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
