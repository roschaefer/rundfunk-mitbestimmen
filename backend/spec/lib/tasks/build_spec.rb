require 'rails_helper'

RSpec.describe 'build:test_and_analyze' do
  include_context 'rake'

  it 'includes all the test and analyze tasks' do
    expect(test_and_analyze_task.prerequisites).to match_array(%w[rubocop rspec brakeman])
  end
end
