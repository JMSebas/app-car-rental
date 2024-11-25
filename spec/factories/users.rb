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

  factory :admin_user, class: 'User' do
    name { 'Maria' }
    lastname { 'Gomez' }
    address { 'Guayaquil' }
    phone { '0976543210' }
    birthdate { '1998-07-25' }
    username { 'mgomez' }
    email { 'maria@example.com' }
    password { 'password123' }
    role { 1 }
  end
end