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

When(/^I visit the decision page$/) do
  visit '/decide'
  expect(page).to have_css('.decision-card-deck')
end

When(/^I decide 'Yes' for ([^"]*) and ([^"]*)$/) do |title1, title2|
  within('.decision-card', text: /#{title1}/) do
    click_on 'Yes'
  end
  within('.decision-card', text: /#{title2}/) do
    click_on 'Yes'
  end
end

When(/^I decide 'No' for ([^"]*)$/) do |title|
  within('.decision-card', text: /#{title}/) do
    click_on 'No'
  end
end

Then(/^the list of selectable broadcasts is empty$/) do
  visit current_url # refresh
  expect(page).to have_css('.decision-card-deck')
  expect(all('.decision-card')).to be_empty
end

Then(/^I the database contains these selections that belong to me:$/) do |table|
  mapping = {'Yes' => 'positive', 'No' => 'neutral'}
  my_selections = @user.selections
  table.hashes.each do |row|
    selection = my_selections.find {|s| s.broadcast.title == row['Title']}
    expect(selection.response).to eq(mapping[row['Answer']])
  end
end

Given(/^I want to give money to each of these broadcasts:$/) do |table|
  table.hashes.each do |row|
    b = create(:broadcast, title: row['Title'])
    create(:selection, user: @user, broadcast: b)
  end
end

When(/^I visit the invoice page$/) do
  visit '/invoice'
end

Then(/^I can see that my budget of ([^"]*)€ is distributed equally:$/) do |budget, table|
  share = budget.to_f/table.rows.length.to_f
  table.hashes.each do |row|
    title = row['Title']
    within('.invoice-item', text: /#{title}/) do
      expect(page).to have_text(share.to_s)
    end
  end
end
