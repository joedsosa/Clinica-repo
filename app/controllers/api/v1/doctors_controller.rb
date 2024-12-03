class Api::V1::DoctorsController < Api::ApiController
  before_action :set_doctor, only: %i[show update destroy]

  # GET api/v1/doctors
  def index
    @doctors = Doctor.filter(filter_params).all

    # Pagination
    @pagination, @doctors = paginate(collection: @doctors, params: page_params)

    json_response(
      DoctorBlueprinter.render(
        @doctors,
        view: :normal,
        root: :data,
        meta: { pagination: @pagination }
      )
    )
  end

  # GET api/v1/doctors/:id
  def show
    json_response(
      DoctorBlueprinter.render(
        @doctor,
        root: :data,
        view: :normal
      )
    )
  end

  # POST api/v1/doctors
  def create
    @doctor = Doctor.new(doctor_params)

    if @doctor.save
      json_response(
        DoctorBlueprinter.render(
          @doctor,
          view: :normal
        ),
        status: :created,
        location: api_v1_doctor_url(@doctor)
      )
    else
      error_messages = @doctor.errors
      json_response(error_messages, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT api/v1/doctors/1
  def update
    if @doctor.update(doctor_params)
      json_response(
        DoctorBlueprinter.render(
          @doctor,
          view: :normal
        ),
        status: :ok,
        location: api_v1_doctor_url(@doctor)
      )
    else
      error_messages = @doctor.errors
      json_response(error_messages, status: :unprocessable_entity)
    end
  end

  # DELETE api/v1/doctors/1
  def destroy
    @doctor.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_doctor
    @doctor = Doctor.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name, :specialty, :start_working_at, :end_working_at)
  end

  def page_params
    params.permit(:page, :per_page, :order_direction, :order_by, :count)
  end

  # filter params
  def filter_params
    params.permit(:first_name, :last_name)
  end
end
