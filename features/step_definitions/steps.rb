Given(/^I am logged in$/) do
  @user = create(:user)
  visit '/login'
  fill_in 'email', with: @user.email
  fill_in 'password', with: @user.password
  click_on 'submit'
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
  fill_in 'email', with: email
  fill_in 'password', with: password
  fill_in 'passwordConfirmation', with: password
end

When(/^I fill in my email and password and click on the submit button$/) do
  email, password = @user.email, @user.password
  fill_in 'email', with: email
  fill_in 'password', with: password
  click_on 'submit'
end

Then(/^a new user was created in the database$/) do
  expect(User.count).to eq 1
end

Given(/^I already signed up$/) do
  @user = create(:user)
end

Then(/^my login was successful$/) do
  using_wait_time(2) do
    expect(page).to have_text('Log out')
  end
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
  wait_for_ajax
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

def check_invoice(ast_table)
  ast_table.hashes.each do |row|
    title = row['Title']
    amount = row['Amount']
    within('.invoice-item', text: /#{title}/) do
      expect(page).to have_text(amount)
    end
  end
end

Then(/^I can see that my budget of .*€ is distributed equally:$/) do |table|
  check_invoice(table)
end

Then(/^also in the database all selections have the same amount of "([^"]*)"$/) do |amount|
  amounts = Selection.pluck(:amount)
  expect(amounts.all? {|a| a == amount.to_f}).to be_truthy
end

Given(/^my invoice looks like this:$/) do |table|
  table.hashes.each do |row|
    title = row['Title']
    amount = row['Amount'].gsub('€','').to_f
    fixed = !! (row['Fixed'] =~ /yes/i)
    broadcast = create(:broadcast, title: title)
    create(:selection,
           user: @user,
           broadcast: broadcast,
           response: :positive,
           amount: amount.to_f,
           fixed: fixed
          )
  end
end

When(/^I look at my invoice/) do
  visit '/invoice'
end

When(/^I click on the 'X' next to ([^"]*)$/) do |title|
  within('.invoice-item', text: /#{title}/) do
    find('.invoice-item-action-remove').click
  end
end

Then(/^my updated invoice looks like this:$/) do |table|
  wait_for_ajax
  check_invoice(table)
end

Then(/^my response to "([^"]*)" is listed in the database as "([^"]*)"$/) do |title, response|
  selection = @user.selections.find {|s| s.broadcast.title == title }
  expect(selection.response).to eq response
end


Given(/^I have many broadcasts in my database, let's say (\d+) broadcasts in total$/) do |number|
  number.to_i.times do
    create(:broadcast)
  end
end

Given(/^there are (\d+) remaining broadcasts in the list$/) do |number|
  expect(page).to have_css('.decision-card-deck')
  expect(page).to have_css('.decision-card', count: number.to_i)
end

Given(/^I click (\d+) times on 'Yes'$/) do |number|
  number.to_i.times do
    first('.decision-card-action', text: /yes/i).click
  end
end

Then(/^the list of broadcasts has (\d+) items again$/) do |number|
  expect(page).to have_css('.decision-card-deck')
  expect(page).to have_css('.decision-card', count: number.to_i)
end

When(/^I change the amount of "([^"]*)" to "([^"]*)" euros$/) do |title, amount|
  within('.invoice-item', text: /#{title}/) do
    find('td', text: /€/).click
    find('input').set(amount)
    click_on 'Save'
  end
end

Then(/^the main part of the invoice looks like this:$/) do |table|
  wait_for_ajax
  check_invoice(table)
end

Then(/^I see the remaining budget at the bottom of the invoice:$/) do |table|
  table.hashes.each do |row|
    label = row['Label']
    amount = row['Amount']
    within('.invoice-footer') do
      within('tr', text: /#{label}/) do
        expect(page).to have_text(amount)
      end
    end
  end
end

When(/^I click on the submit button$/) do
  click_on 'submit'
end

When(/^I click on the german flag$/) do
  click_on 'German'
end

Then(/^I(?: can)? see "([^"]*)" and "([^"]*)" menu items$/) do |label1, label2|
  expect(page).to have_css('.button', text: label1)
  expect(page).to have_css('.button', text: label2)
end

When(/^I fill in an invalid email like "([^"]*)"$/) do |email|
  password = '12341234'
  fill_in 'email', with: email
  fill_in 'password', with: password
  fill_in 'passwordConfirmation', with: password
end

Then(/^I can see the error message in english:$/) do |string|
  expect(page).to have_text(string)
end

