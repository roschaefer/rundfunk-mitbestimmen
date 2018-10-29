require 'rails_helper'

RSpec.describe 'rubocop_brakeman_rspec:all' do
  it { is_expected.to include('rspec') }
  it { is_expected.to include('rubocop') }
  it { is_expected.to include('brakeman') }
end
