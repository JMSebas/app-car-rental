# # spec/models/client_spec.rb
# require 'rails_helper'

# RSpec.describe Client, type: :model do
#   # 1. Validaciones

#   context 'validations' do
#     # Verifica que el campo 'name' esté presente
#     it { should validate_presence_of(:name) }

#     # Verifica que el campo 'email' esté presente
#     it { should validate_presence_of(:email) }

#     # Verifica que el campo 'email' sea único
#     it { should validate_uniqueness_of(:email) }

#     # Verifica que 'email' tenga un formato válido
#     it { should allow_value('test@example.com').for(:email) }
#     it { should_not allow_value('invalid-email').for(:email) }

#     # Verifica que la longitud del 'name' no sea mayor a 255 caracteres
#     it { should validate_length_of(:name).is_at_most(255) }

#     # Verifica que 'email' no tenga más de 255 caracteres
#     it { should validate_length_of(:email).is_at_most(255) }

#     # Verifica que 'phone' sea opcional pero esté en el formato correcto si se proporciona
#     it { should allow_value('123-456-7890').for(:phone) }
#     it { should_not allow_value('12345').for(:phone) }

#     # Verifica que 'role' sea un valor dentro del enum
#     it { should define_enum_for(:role).with_values([:client, :administrator, :employee]) }
#   end

#   # 2. Asociaciones

#   context 'associations' do
#     # Verifica que el cliente tenga muchas reservas
#     it { should have_many(:reservations) }

#     # Verifica que el cliente tenga muchas rentas
#     it { should have_many(:rentals) }

#     # Verifica que el cliente tenga muchas facturas
#     it { should have_many(:invoices) }
#   end

#   # 3. Métodos personalizados

#   context 'custom methods' do
#     # Verifica si el método full_name devuelve el nombre completo
#     it 'returns the full name of the client' do
#       client = Client.create(name: 'John', lastname: 'Doe')
#       expect(client.full_name).to eq('John Doe')
#     end

#     # Verifica si el método de descuento (si existe) devuelve el valor correcto
#     it 'calculates the correct discount' do
#       client = Client.create(name: 'Jane', email: 'jane@example.com')
#       expect(client.calculate_discount).to eq(0.10) # Asegúrate de que este valor sea el correcto
#     end
#   end

#   # 4. Prueba de creación y validación

#   context 'creating a new client' do
#     it 'is valid with valid attributes' do
#       client = Client.new(name: 'Jane', email: 'jane@example.com', phone: '123-456-7890')
#       expect(client).to be_valid
#     end

#     it 'is invalid without a name' do
#       client = Client.new(email: 'jane@example.com')
#       expect(client).not_to be_valid
#     end

#     it 'is invalid without an email' do
#       client = Client.new(name: 'Jane')
#       expect(client).not_to be_valid
#     end

#     it 'is invalid with an invalid email format' do
#       client = Client.new(name: 'Jane', email: 'invalid-email')
#       expect(client).not_to be_valid
#     end
#   end

#   # 5. Comportamiento de objetos: asegurando que los cambios de atributos se reflejan

#   context 'attribute changes' do
#     it 'updates the email correctly' do
#       client = Client.create(name: 'John', email: 'john@example.com')
#       client.update(email: 'newemail@example.com')
#       expect(client.email).to eq('newemail@example.com')
#     end

#     it 'does not allow invalid phone numbers' do
#       client = Client.create(name: 'John', email: 'john@example.com', phone: '12345')
#       expect(client.phone).to be_nil # Si el formato es incorrecto, el teléfono debería ser nulo
#     end
#   end

#   # 6. Prueba de roles

#   context 'roles' do
#     it 'has a default role of client' do
#       client = Client.create(name: 'John', email: 'john@example.com')
#       expect(client.role).to eq('client')
#     end

#     it 'can be assigned to a different role' do
#       client = Client.create(name: 'John', email: 'john@example.com', role: :administrator)
#       expect(client.role).to eq('administrator')
#     end
#   end

#   # 7. Pruebas de asociaciones con otras tablas

#   context 'associated records' do
#     it 'can have many reservations' do
#       client = Client.create(name: 'Jane', email: 'jane@example.com')
#       reservation = Reservation.create(user: client, vehicle_id: 1, reservation_date: Date.today)
#       expect(client.reservations).to include(reservation)
#     end

#     it 'can have many rentals' do
#       client = Client.create(name: 'John', email: 'john@example.com')
#       rental = Rental.create(user: client, rate_id: 1, reservation_id: 1, actual_reservation_date: Date.today)
#       expect(client.rentals).to include(rental)
#     end
#   end
# end
