RSpec.shared_examples 'database unique attribute' do |factory, args|
  before { build(factory, args).save! } # create the duplicate record
  specify { expect( build(factory, args) ).not_to be_valid }
  specify { expect{ build(factory, args).save(validate: false) }.to raise_exception(ActiveRecord::RecordNotUnique) }
end
