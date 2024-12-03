# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts 'Creating default user roles'
puts '*------------------------*'

# Create a default admin user
if Rails.env.development?
  admin = User.find_or_create_by!(email: 'admin@test.com') do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
    user.confirmed_at = Time.zone.now
    user.confirmation_sent_at = Time.zone.now
    user.first_name = 'Admin'
    user.last_name = 'User'
    user.role = :admin
    user.admin = true
  end

  AdminUser.find_or_create_by!(email: 'admin_user@test.com') do |admin_user|
    admin_user.password = 'password'
    admin_user.password_confirmation = 'password'
  end

  # Print the admin user created
  puts "Admin user created: #{admin.email}"

  puts '*------------------------*'

  # Create data for the Doctor model
  puts 'Creating default doctors'

  doctor_data = [
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      specialty: 'Cardiology',
      start_working_at: Time.zone.now,
      end_working_at: Time.zone.now + 2.hours
    },
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      specialty: 'Dermatology',
      start_working_at: Time.zone.now,
      end_working_at: Time.zone.now + 2.hours
    },
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      specialty: 'Endocrinology',
      start_working_at: Time.zone.now,
      end_working_at: Time.zone.now + 2.hours
    },
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      specialty: 'Gastroenterology',
      start_working_at: Time.zone.now,
      end_working_at: Time.zone.now + 2.hours
    }
  ]

  # Create the Doctor records
  doctor_data.each do |doctor|
    doctor_record = Doctor.find_or_create_by!(doctor)
    puts "Doctor created: #{doctor_record.first_name} #{doctor_record.last_name}"
  end

  # Create data for the Patient model
  puts 'Creating default patients'

  patient_data = [
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      allergies: Faker::Lorem.sentence(word_count: 3),
      blood_type: 'A+',
      current_medications: Faker::Lorem.sentence(word_count: 5),
      emergency_contact_name: Faker::Name.name,
      emergency_contact_phone: '+50499995500'
    },
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      allergies: Faker::Lorem.sentence(word_count: 3),
      blood_type: 'A+',
      current_medications: Faker::Lorem.sentence(word_count: 5),
      emergency_contact_name: Faker::Name.name,
      emergency_contact_phone: '+50499995500'
    },
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      allergies: Faker::Lorem.sentence(word_count: 3),
      blood_type: 'A+',
      current_medications: Faker::Lorem.sentence(word_count: 5),
      emergency_contact_name: Faker::Name.name,
      emergency_contact_phone: '+50499995500'
    },
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      allergies: Faker::Lorem.sentence(word_count: 3),
      blood_type: 'A+',
      current_medications: Faker::Lorem.sentence(word_count: 5),
      emergency_contact_name: Faker::Name.name,
      emergency_contact_phone: '+50499995500'
    }
  ]

  # Create the patient records
  patient_data.each do |patient|
    patient_record = Patient.find_or_create_by!(patient)
    puts "Patient created: #{patient_record.first_name} #{patient_record.last_name}"
  end

  puts '*------------------------*'
  puts 'Creating default MedicalRecords'

  # Recuperar doctores y pacientes creados previamente
  doctors = Doctor.all
  patients = Patient.all

  # Crear registros de MedicalRecord
  medical_records_data = doctors.zip(patients) # Une cada doctor con un paciente
  medical_records_data.each do |doctor, patient|
    if doctor && patient
      medical_record = MedicalRecord.find_or_create_by!(doctor: doctor, patient: patient)
      puts "MedicalRecord created for Doctor: #{medical_record.doctor.first_name} #{medical_record.doctor.last_name} - Patient: #{medical_record.patient.first_name}#{medical_record.patient.last_name}"
    else
      puts 'Error: Missing doctor or patient for MedicalRecord creation.'
    end
  end

  puts '*------------------------*'
  puts 'Creating default MedicalRecordNotes'

  puts '*------------------------*'
  puts 'Creating default MedicalRecordNotes'

  # Recuperar registros médicos existentes
  medical_records = MedicalRecord.all

  # Crear notas para cada registro médico
  medical_records.each do |medical_record|
    note_description = Faker::Lorem.paragraph(sentence_count: 3)

    medical_record_note = MedicalRecordNote.find_or_create_by!(
      description: note_description,
      doctor: medical_record.doctor,
      medical_record: medical_record,
      user_id: 1
    )

    puts "MedicalRecordNote created: #{medical_record_note.description} - Doctor: #{medical_record.doctor.first_name} #{medical_record.doctor.last_name}"
  end

  # Create data for the reviews model
  puts 'Creating default reviews'

  reviews_data = [
    {
      email: Faker::Internet.email,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      rating: rand(0..5),
      title: Faker::Lorem.sentence(word_count: 3),
      description: Faker::Lorem.paragraph(sentence_count: 2)
    },
    {
      email: Faker::Internet.email,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      rating: rand(0..5),
      title: Faker::Lorem.sentence(word_count: 3),
      description: Faker::Lorem.paragraph(sentence_count: 2)
    },
    {
      email: Faker::Internet.email,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      rating: rand(0..5),
      title: Faker::Lorem.sentence(word_count: 3),
      description: Faker::Lorem.paragraph(sentence_count: 2)
    },
    {
      email: Faker::Internet.email,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      rating: rand(0..5),
      title: Faker::Lorem.sentence(word_count: 3),
      description: Faker::Lorem.paragraph(sentence_count: 2)
    }
  ]

  # Create the reviews records
  reviews_data.each do |review|
    review_record = Review.find_or_create_by!(review)
    puts "Review created: #{review_record.first_name} #{review_record.title}"
  end

elsif Rails.env.production?
  User.find_or_create_by!(email: 'admin@email.com') do |user|
    user.password = 'dbClinica2024'
    user.password_confirmation = 'dbClinica2024'
    user.confirmed_at = Time.zone.now
    user.confirmation_sent_at = Time.zone.now
    user.first_name = 'Admin'
    user.last_name = 'User'
    user.role = :admin
    user.admin = true
  end

  AdminUser.find_or_create_by!(email: 'backend-admin@email.com') do |admin_user|
    admin_user.password = 'dbClinica2024'
    admin_user.password_confirmation = 'dbClinica2024'
  end
end
