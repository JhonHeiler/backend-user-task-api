require 'rails_helper'

RSpec.describe "Api::Tasks", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/api/tasks/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/api/tasks/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/api/tasks/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/api/tasks/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/api/tasks/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
