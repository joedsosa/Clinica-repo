require 'rails_helper' # Ensure Rails is loaded

RSpec.configure do |config|
  config.openapi_root = "#{Rails.root}/swagger" # Updated from swagger_root

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Clinic API',
        version: 'v1'
      },
      paths: {},
      components: {
        schemas: {
          # Doctor schema
          doctor: {
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  first_name: { type: :string },
                  last_name: { type: :string },
                  specialty: { type: :string },
                  start_working_at: { type: :string, format: :time },
                  end_working_at: { type: :string, format: :time },
                  created_at: { type: :string },
                  updated_at: { type: :string }
                },
                required: %w[id first_name last_name specialty start_working_at end_working_at]
              }
            }
          },
          doctors: {
            type: :object,
            properties: {
              data: {
                type: :array,
                items: { '$ref' => '#/components/schemas/doctor' }
              },
              meta: { type: :object }
            },
            required: %w[data meta]
          },
          new_doctor: {
            type: :object,
            properties: {
              id: { type: :integer },
              first_name: { type: :string },
              last_name: { type: :string },
              specialty: { type: :string },
              start_working_at: { type: :string, format: :time },
              end_working_at: { type: :string, format: :time },
              created_at: { type: :string },
              updated_at: { type: :string }
            },
            required: %w[id first_name last_name specialty start_working_at end_working_at]
          },
          # Patient schema
          patient: {
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  first_name: { type: :string },
                  last_name: { type: :string },
                  allergies: { type: :string },
                  current_medications: { type: :string },
                  emergency_contact_name: { type: :string },
                  emergency_contact_phone: { type: :string },
                  blood_type: { type: :string },
                  age: { type: :integer },
                  birth_date: { type: :string, format: :date },
                  created_at: { type: :string },
                  updated_at: { type: :string }
                },
                required: %w[id first_name last_name]
              }
            }
          },
          patients: {
            type: :object,
            properties: {
              data: {
                type: :array,
                items: { '$ref' => '#/components/schemas/patient' }
              },
              meta: { type: :object }
            },
            required: %w[data meta]
          },
          new_patient: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              allergies: { type: :string },
              current_medications: { type: :string },
              emergency_contact_name: { type: :string },
              emergency_contact_phone: { type: :string },
              blood_type: { type: :string },
              created_at: { type: :string },
              updated_at: { type: :string }
            },
            required: %w[first_name last_name]
          },
          # Medical Record schema
          medical_record: {
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  doctor_id: { type: :integer },
                  patient_id: { type: :integer },
                  created_at: { type: :string },
                  updated_at: { type: :string }
                },
                required: %w[id doctor_id patient_id]
              }
            }
          },
          medical_records: {
            type: :object,
            properties: {
              data: {
                type: :array,
                items: { '$ref' => '#/components/schemas/medical_record' },
                minItems: 0 # Allow empty arrays
              },
              meta: { type: :object }
            },
            required: %w[data meta]
          },
          new_medical_record: {
            type: :object,
            properties: {
              doctor_id: { type: :integer },
              patient_id: { type: :integer }
            },
            required: %w[doctor_id patient_id]
          },
          # Review schema
          review: {
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  email: { type: :string, format: :email },
                  first_name: { type: :string },
                  last_name: { type: :string },
                  rating: { type: :integer, minimum: 0, maximum: 5 },
                  title: { type: :string },
                  description: { type: :string },
                  created_at: { type: :string, format: :date_time },
                  updated_at: { type: :string, format: :date_time }
                },
                required: %w[id email first_name last_name rating title description]
              }
            }
          },
          reviews: {
            type: :object,
            properties: {
              data: {
                type: :array,
                items: { '$ref' => '#/components/schemas/review' }
              },
              meta: { type: :object }
            },
            required: %w[data meta]
          },
          new_review: {
            type: :object,
            properties: {
              email: { type: :string, format: :email },
              first_name: { type: :string },
              last_name: { type: :string },
              rating: { type: :integer, minimum: 0, maximum: 5 },
              title: { type: :string },
              description: { type: :string }
            },
            required: %w[email first_name last_name rating title description]
          },
          subscription: {
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  email: { type: :string, format: :email },
                  first_name: { type: :string },
                  last_name: { type: :string },
                  terms_and_conditions: { type: :boolean },
                  created_at: { type: :string, format: :date_time },
                  updated_at: { type: :string, format: :date_time }
                },
                required: %w[id email first_name last_name terms_and_conditions]
              }
            }
          },
          subscriptions: {
            type: :object,
            properties: {
              data: {
                type: :array,
                items: { '$ref' => '#/components/schemas/subscription' }
              },
              meta: { type: :object }
            },
            required: %w[data meta]
          },
          new_subscription: {
            type: :object,
            properties: {
              email: { type: :string, format: :email },
              first_name: { type: :string },
              last_name: { type: :string },
              terms_and_conditions: { type: :boolean }
            },
            required: %w[email first_name last_name terms_and_conditions]
          },
          medical_record_note: {
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  description: { type: :string },
                  doctor_id: { type: :integer },
                  medical_record_id: { type: :integer },
                  user_id: { type: :integer },
                  created_at: { type: :string, format: :date_time },
                  updated_at: { type: :string, format: :date_time }
                },
                required: %w[id description doctor_id medical_record_id user_id]
              }
            }
          },
          medical_record_notes: {
            type: :object,
            properties: {
              data: {
                type: :array,
                items: { '$ref' => '#/components/schemas/medical_record_note' }
              },
              meta: { type: :object }
            },
            required: %w[data meta]
          },
          new_medical_record_note: {
            type: :object,
            properties: {
              description: { type: :string },
              doctor_id: { type: :integer },
              medical_record_id: { type: :integer },
              user_id: { type: :integer }
            },
            required: %w[description doctor_id medical_record_id user_id]
          },
          medicine: {
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  name: { type: :string },
                  description: { type: :string },
                  dosage: { type: :string },
                  dosage_form: { type: :string },
                  instructions: { type: :string },
                  created_at: { type: :string, format: :date_time },
                  updated_at: { type: :string, format: :date_time }
                },
                required: %w[name description dosage dosage_form instructions]
              }
            }
          },
          medicines: {
            type: :object,
            properties: {
              data: {
                type: :array,
                items: { '$ref' => '#/components/schemas/medicine' }
              },
              meta: { type: :object }
            },
            required: %w[data meta]
          },
          new_medicine: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              dosage: { type: :string },
              instructions: { type: :string },
              dosage_form: { type: :string }
            },
            required: %w[name description dosage dosage_form instructions]
          },
          diagnosis: {
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  description: { type: :string },
                  doctor_id: { type: :integer },
                  patient_id: { type: :integer },
                  created_at: { type: :string, format: :date_time },
                  updated_at: { type: :string, format: :date_time }
                },
                required: %w[description doctor_id patient_id]
              }
            }
          },
          diagnoses: {
            type: :object,
            properties: {
              data: {
                type: :array,
                items: { '$ref' => '#/components/schemas/diagnosis' }
              },
              meta: { type: :object }
            },
            required: %w[data meta]
          },
          new_diagnosis: {
            type: :object,
            properties: {
              description: { type: :string },
              doctor_id: { type: :integer },
              patient_id: { type: :integer }
            },
            required: %w[description doctor_id patient_id]
          },
          medical_prescription: {
            type: :object,
            properties: {
              id: { type: :integer },
              medication_name: { type: :string },
              dosage: { type: :string },
              instructions: { type: :string },
              patient_id: { type: :integer },
              doctor_id: { type: :integer }, # Si el doctor es necesario
              frequency: { type: :string },  # Agregar los campos necesarios
              start_date: { type: :string, format: :date },
              end_date: { type: :string, format: :date },
              created_at: { type: :string, format: :date_time },
              updated_at: { type: :string, format: :date_time }
            },
            required: %w[id medication_name dosage instructions patient_id doctor_id start_date end_date]
          },
          medical_prescriptions: {
            type: :object,
            properties: {
              data: {
                type: :array,
                items: { '$ref' => '#/components/schemas/medical_prescription' }
              },
              meta: { type: :object }
            },
            required: %w[data meta]
          },
          new_medical_prescription: {
            type: :object,
            properties: {
              medication_name: { type: :string },
              dosage: { type: :string },
              instructions: { type: :string },
              patient_id: { type: :integer },
              doctor_id: { type: :integer }, # Si aplica
              frequency: { type: :string },
              start_date: { type: :string, format: :date },
              end_date: { type: :string, format: :date }
            },
            required: %w[medication_name dosage instructions patient_id doctor_id start_date end_date]
          }
        }
      }
    }
  }

  config.openapi_format = :yaml # Updated from swagger_format
end
