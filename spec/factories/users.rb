FactoryBot.define do
    factory :user do
      name { "John" }
      lastname { "Doe" }
      address { "123 Main St" }
      phone { "1234567890" }
      email { "john.doe@example.com" }
      username { "johndoe" }
      password { "password" }
      birthdate { Date.today }
    end
  end
  