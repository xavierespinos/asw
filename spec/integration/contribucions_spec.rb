# spec/integration/contribucions_spec.rb
require 'swagger_helper'

describe 'Hackersnews API' do

  path '/apps/controllers/api/contribucions/{id}' do

    get 'Retrieves a contribution' do
      tags 'Contribucions'
      produces 'application/json', 'application/xml'
      parameter name: :id, :in => :path, :type => :string

      response '200', 'name found' do
        schema type: :object,
          properties: {
            id: { type: :integer, },
            name: { type: :string },
          },
          required: [ 'id', 'name', 'status' ]

        let(:id) { Contribucions.create(titol: 'foo')}
        run_test!
      end

      response '404', 'pet not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end