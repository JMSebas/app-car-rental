# Swagger::Blocks.build_root_json('/api-docs') do
#     key :swagger, '2.0'
#     key :info do
#       key :title, 'Mi API'
#       key :description, 'Documentación de la API de ejemplo'
#       key :version, '1.0.0'
#     end
#     key :host, 'localhost:3000'
#     key :basePath, '/'
#     key :schemes, ['http']
  
#     # Documentar los modelos (schemas) que vas a usar
#     swagger_schema :Vehicle do
#       key :required, [:id, :brand, :model, :license_plate, :year, :type, :status, :daily_rate]
#       property :id do
#         key :type, :integer
#         key :format, :int64
#       end
#       property :brand do
#         key :type, :string
#       end
#       property :model do
#         key :type, :string
#       end
#       property :license_plate do
#         key :type, :string
#       end
#       property :year do
#         key :type, :integer
#       end
#       property :type do
#         key :type, :string
#       end
#       property :status do
#         key :type, :string
#       end
#       property :daily_rate do
#         key :type, :number
#         key :format, :float
#       end
#     end
  
#     # Documentar los endpoints (rutas) de tu API
#     swagger_path '/vehicles' do
#       operation :get do
#         key :summary, 'Obtener todos los vehículos'
#         key :description, 'Devuelve una lista de todos los vehículos'
#         key :produces, ['application/json']
#         response :ok do
#           key :description, 'Lista de vehículos'
#           schema do
#             key :type, :array
#             items do
#               key :'$ref', :Vehicle
#             end
#           end
#         end
#       end
#     end
#   end
  