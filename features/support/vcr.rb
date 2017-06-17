require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'features/cassettes'
  c.ignore_localhost = true
end

VCR.cucumber_tags do |t|
  t.tag  '@vcr'
end
