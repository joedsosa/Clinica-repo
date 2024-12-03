class Api::V1::PatientsController < Api::ApiController
  before_action :set_patient, only: %i[show update destroy]

  # GET api/v1/patients
  def index
    @patients = Patient.filter(filter_params).all

    # Pagination
    @pagination, @patients = paginate(collection: @patients, params: page_params)

    json_response(
      PatientBlueprinter.render(
        @patients,
        view: :normal,
        root: :data,
        meta: { pagination: @pagination }
      )
    )
  end

  # GET api/v1/patients/:id
  def show
    json_response(
      PatientBlueprinter.render(
        @patient,
        root: :data,
        view: :normal
      )
    )
  end

  # POST api/v1/patients
  def create
    @patient = Patient.new(patient_params)

    if @patient.save
      json_response(
        PatientBlueprinter.render(
          @patient,
          view: :normal
        ),
        status: :created,
        location: api_v1_patient_url(@patient)
      )
    else
      error_messages = @patient.errors
      json_response(error_messages, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT api/v1/patients/:id
  def update
    if @patient.update(patient_params)
      json_response(
        PatientBlueprinter.render(
          @patient,
          view: :normal
        ),
        status: :ok
      )
    else
      error_messages = @patient.errors
      json_response(error_messages, status: :unprocessable_entity)
    end
  end

  # DELETE api/v1/patients/:id
  def destroy
    @patient.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_patient
    @patient = Patient.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def patient_params
    params.require(:patient).permit(
      :first_name, :last_name, :allergies, :current_medications,
      :emergency_contact_name, :emergency_contact_phone, :blood_type,
      :age, :birth_date
    )
  end

  def page_params
    params.permit(:page, :per_page, :order_direction, :order_by, :count)
  end

  # Filter params
  def filter_params
    params.permit(:first_name, :last_name)
  end
end
