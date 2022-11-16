require 'rails_helper'

RSpec.describe 'Users', type: :request do

  before do
    allow_any_instance_of(UsersController).to(
      receive(:validate_auth_scheme).and_return(true))
    allow_any_instance_of(UsersController).to(
      receive(:authenticate_client).and_return(true))
  end

  let(:john) { create(:user) }
  let(:users) { [john] }

  before { users }

  describe 'GET /api/users' do
    before { get '/api/users' }
    
    it 'gets HTTP status 200' do
      expect(response.status).to eq 200
    end

    it 'receives a json with the "data" root key' do
      expect(json_body['data']).to_not be nil
    end

    it 'receives all 1 user' do
      expect(json_body['data'].size).to eq 1
    end

  end

  describe 'GET /api/users/:id' do
    before { get "/api/users/#{john.id}" }

    context 'with existing resource' do

      it 'gets HTTP status 200' do
        expect(response.status).to eq 200
      end

      it 'receives the "john" user as JSON' do
        expected = { data: UserPresenter.new(john, {}).fields.embeds }
        expect(response.body).to eq(expected.to_json)
      end

    end

    context 'with nonexistent resource' do
      it 'gets HTTP status 404' do
        get '/api/users/2314323'
        expect(response.status).to eq 404
      end
    end

  end

  describe 'POST /api/users' do

    

  end

  describe 'PATCH /api/users/:id' do
  end

  describe 'DELETE /api/users/:id' do
  end
end