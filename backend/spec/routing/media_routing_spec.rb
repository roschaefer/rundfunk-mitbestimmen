require 'rails_helper'

RSpec.describe MediaController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/media').to route_to('media#index')
    end

    it 'routes to #show' do
      expect(get: '/media/1').to route_to('media#show', id: '1')
    end
  end
end
