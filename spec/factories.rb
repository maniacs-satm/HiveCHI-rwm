FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email}
    phone { "555#{Array.new(7) { rand(10).to_s }.join}"}
    password "password1234"
    password_confirmation "password1234"

    factory :verified_user do
      email_verified true
      phone_verified true
    end
  end

  factory :student do
    username { Faker::Internet.user_name }
    school_id { create(:school).id }
    home_address { "#{Faker::Address.street_address}, Chicago, IL" }
    user_attributes { FactoryGirl.attributes_for(:user) }
    nudges_enabled true

    factory :verified_student do
      user_attributes { FactoryGirl.attributes_for(:verified_user) }
      can_nudge true
    end
  end

  factory :service_provider do
    organization { create(:organization) }
    user_attributes do
      FactoryGirl.attributes_for(:user, email: SecureRandom.hex(5) + "@" + organization.domain_name)
    end

    factory :verified_service_provider do
      user_attributes do
        FactoryGirl.attributes_for(:verified_user, email: SecureRandom.hex(5)+ "@" + organization.domain_name)
      end
    end
  end

  factory :admin do
    user_attributes { FactoryGirl.attributes_for(:verified_user) }
  end

  factory :school do
    name { "#{Faker::Company.name} High School" }
    address { "#{Faker::Address.street_address}, Chicago, IL" }
  end

  factory :event do
    name { "Test Event #{SecureRandom.hex(10)}" }
    address "875 N Michigan Ave, Chicago, IL"
    start_date_and_time { Date.tomorrow.midday }
    duration { rand(4) + 1 }
    description "This is an automatically generated test event."
    event_type "Other"
    organization_id { create(:organization).id }
  end

  factory :attendance do
    event_id { create(:event).id }
    student_id { create(:verified_student).id }
    commitment_status { "Yes" }
  end

  factory :nudge do
    nudger_id { create(:verified_student).id }
    nudgee_id { create(:verified_student).id }
    event_id { create(:event).id }
  end

  factory :organization do
    name { Faker::Company.name }
    domain_name { "@#{SecureRandom.hex(10)}.com" }
  end
end
