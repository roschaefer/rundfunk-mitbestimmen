Given(/^I am logged in$/) do
  @user = create(:user)
  visit '/login'
  fill_in 'login-form-email', with: @user.email
  fill_in 'login-form-password', with: @user.password
  click_on 'login-form-submit'
  expect(page).to have_text('Log out')
end

Given(/^I have these broadcasts in my database:$/) do |table|
  table.hashes.each do |row|
    create :broadcast, title: row['Title']
  end
end

When(/^I visit the filter page$/) do
  visit '/filter'
end

Then(/^I can read.*'(.+)'$/) do |string|
  expect(page).to have_text string
end

When(/^I visit the landing page$/) do
  visit '/'
end

Then(/^I can read:$/) do |string|
  expect(page).to have_text string
end

Given(/^my browser language is set to german$/) do
  expect(ENV["LANG"]).to eq 'de_DE.UTF-8'
end

Then(/^I am welcomed with "([^"]*)"$/) do |string|
  expect(page).to have_text string
end

When(/^I click on the continue button to the filter page$/) do
  click_on 'continue-to-filter'
end

When(/^I click on "([^"]*)"$/) do |string|
  click_on string
end

When(/^I fill in my email and password and confirm the password$/) do
  email, password = 'test@example.org', '12341234'
  fill_in 'signup-form-email', with: email
  fill_in 'signup-form-password', with: password
  fill_in 'signup-form-password-confirmation', with: password
end

When(/^I fill in my email and password and click on 'Send'$/) do
  email, password = @user.email, @user.password
  fill_in 'login-form-email', with: email
  fill_in 'login-form-password', with: password
  click_on 'Send'
end

Then(/^a new user was created in the database$/) do
  expect(User.count).to eq 1
end

Given(/^I already signed up$/) do
  @user = create(:user)
end

Then(/^my login was successful$/) do
  expect(page).to have_text('Log out')
end
