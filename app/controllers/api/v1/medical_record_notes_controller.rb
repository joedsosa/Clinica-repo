class Api::V1::MedicalRecordNotesController < Api::ApiController
  before_action :set_medical_record_note, only: %i[show update destroy]

  # GET /api/v1/medical_record_notes
  def index
    @medical_record_notes = MedicalRecordNote.filter(filter_params).all

    # Paginación
    @pagination, @medical_record_notes = paginate(collection: @medical_record_notes, params: page_params)

    json_response(
      MedicalRecordNoteBlueprinter.render(
        @medical_record_notes,
        view: :normal,
        root: :data,
        meta: { pagination: @pagination }
      )
    )
  end

  # GET /api/v1/medical_record_notes/:id
  def show
    json_response(
      MedicalRecordNoteBlueprinter.render(
        @medical_record_note,
        root: :data,
        view: :normal
      )
    )
  end

  # POST /api/v1/medical_record_notes
  def create
    @medical_record_note = MedicalRecordNote.new(medical_record_note_params)

    if @medical_record_note.save
      json_response(
        MedicalRecordNoteBlueprinter.render(
          @medical_record_note,
          view: :normal
        ),
        status: :created,
        location: api_v1_medical_record_note_url(@medical_record_note)
      )
    else
      json_response(@medical_record_note.errors, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /api/v1/medical_record_notes/:id
  def update
    if @medical_record_note.update(medical_record_note_params)
      json_response(
        MedicalRecordNoteBlueprinter.render(
          @medical_record_note,
          view: :normal
        ),
        status: :ok,
        location: api_v1_medical_record_note_url(@medical_record_note)
      )
    else
      json_response(@medical_record_note.errors, status: :unprocessable_entity)
    end
  end

  # DELETE /api/v1/medical_record_notes/:id
  def destroy
    @medical_record_note.destroy
    head :no_content
  end

  private

  # Callbacks para encontrar registros
  def set_medical_record_note
    @medical_record_note = MedicalRecordNote.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  # Solo permitir parámetros confiables
  def medical_record_note_params
    params.require(:medical_record_note).permit(:doctor_id, :user_id, :medical_record_id, :description)
  end

  # Parámetros de paginación
  def page_params
    params.permit(:page, :per_page, :order_direction, :order_by)
  end

  # Filtros básicos
  def filter_params
    params.permit(:id, :doctor_id, :medical_record_id)
  end
end
