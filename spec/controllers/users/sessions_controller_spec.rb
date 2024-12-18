require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  let(:user) { create(:user) } 

  describe "POST #create" do
    it "logs in the user" do
      post :create, params: { user: { email: user.email, password: user.password } }
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["status"]["data"]["id"]).to eq(user.id) # Acceso correcto a los datos.
    end

    it "returns an error for invalid credentials" do
      post :create, params: { user: { email: user.email, password: "wrongpassword" } }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  

  describe "DELETE #destroy" do
  before do
    sign_in user 
    
    request.headers['Authorization'] = "Bearer #{Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first}" 
  end

  it "logs out the user" do
    delete :destroy
    expect(response).to have_http_status(:ok)
  end

  it "returns an error for a user with no active session" do
    sign_out user
    
    request.headers['Authorization'] = "Bearer invalid_token"
    delete :destroy
    
    expect(response).to have_http_status(:unauthorized)
  end
  

end




end
