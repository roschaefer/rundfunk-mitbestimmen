Given(/^I have these broadcasts in my database:$/) do |table|
  table.hashes.each do |row|
    create :broadcast, title: row['Title']
  end
end

When(/^I visit the filter page$/) do
  visit '/filter'
end

Then(/^I can read.*'(.+)'$/) do |text|
  expect(page).to have_text text
end

