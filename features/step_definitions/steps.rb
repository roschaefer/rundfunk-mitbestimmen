def sanitize_amount(amount)
  amount.gsub('€','').to_f
end

Given(/^I am logged in$/) do
  @user = create(:user)
  visit '/login'
  fill_in 'email', with: @user.email
  fill_in 'password', with: @user.password
  click_on 'submit'
  expect(page).to have_text('Log out')
end

Given(/^(?:I|we) have (?:these|this) broadcast(?:s)? in (?:my|our) database:$/) do |table|
  table.hashes.each do |row|
    create(:broadcast,
           title: row['Title'],
           medium: (row['Medium'] || 'tv')
          )
  end
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

When(/^I click on the continue button to the decide page$/) do
  click_on 'continue-to-decide'
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
  expect(page).to have_css('.decision-page')
end

When(/^I decide 'Yes' for ([^"]*) and ([^"]*) but 'No' for ([^"]*)$/) do |title1, title2, title3|
  3.times do
    wait_for_transition('.decision-card')
    expect(page).to have_css('.decision-card.fully-displayed')
    card = find('.decision-card.fully-displayed')
    [title1, title2].each do |title|
      if card.text.include? title
        find('.positive').click
      end
    end
    if card.text.include? title3
      find('.neutral').click
    end
  end
end

Then(/^the list of selectable broadcasts is empty$/) do
  wait_for_ajax
  expect(page).to have_css('.decision-page')
  expect(page).to have_css('.decision-card', count: 1) # the last one
  expect(page).not_to have_css('.decision-card-action.positive')
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
    amount = sanitize_amount(row['Amount'])
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
  invoice_table = find('#invoice-table')
  scroll_to(invoice_table)
  invoice_item = find('.invoice-item', text: /#{title}/)
  within(invoice_item) do
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
  expect(page).to have_css('.decision-page')
  expect(page).to have_css('.decision-card', count: number.to_i)
end

Given(/^I click (\d+) times on 'Yes'$/) do |number|
  number.to_i.times do
    wait_for_transition('.decision-card')
    expect(page).to have_css('.decision-card-action.positive')
    find('.decision-card-action.positive').click
  end
end

Then(/^the list of broadcasts has (\d+) items again$/) do |number|
  expect(page).to have_css('.decision-page')
  expect(page).to have_css('.decision-card', count: number.to_i)
end

When(/^I change the amount of "([^"]*)" to "([^"]*)" euros$/) do |title, amount|
  invoice_table = find('#invoice-table')
  scroll_to(invoice_table)
  invoice_item = find('.invoice-item', text: /#{title}/)
  within(invoice_item) do
    find('.ember-inline-edit', text: /€/).click
    find('input').set(amount)
    find('.ember-inline-edit-save').click
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
  click_on 'Deutsch'
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

When(/^I click on the lock symbol next to "([^"]*)"$/) do |title|
  invoice_table = find('#invoice-table')
  scroll_to(invoice_table)
  invoice_item = find('.invoice-item', text: /#{title}/)
  within(invoice_item) do
    find('.invoice-item-action-fix').click
  end
  wait_for_ajax
end

Given(/^the attribute 'fixed' is "([^"]*)" for my selected broadcast "([^"]*)"$/) do |value, title|
  selection = @user.selections.find {|s| s.broadcast.title ==  title }
  selection.reload
  if value == 'true'
    expect(selection).to be_fixed
  else
    expect(selection).not_to be_fixed
  end
end

When(/^I click on the unlock symbol next to "([^"]*)"$/) do |title|
  invoice_table = find('#invoice-table')
  scroll_to(invoice_table)
  invoice_item = find('.invoice-item', text: /#{title}/)
  within(invoice_item) do
    find('.invoice-item-action-unfix').click
  end
end

Given(/^these users want to pay money for these broadcasts:$/) do |table|
  table.hashes.each do |row|
    broadcast = Broadcast.find_by(title: row['Broadcast'])
    unless broadcast
      broadcast = create(:broadcast, title: row['Broadcast'])
    end
    user = User.find_by(email: row['Email'])
    unless user
      user = create(:user,
                    email: row['Email'],
                    password: 'secret1234',
                    password_confirmation: 'secret1234')
    end
    create(:selection,
           broadcast: broadcast,
           user: user,
           response: :positive,
           amount: sanitize_amount(row['Amount']))
  end
end

When(/^I visit the public balances page$/) do
  visit '/balances'
end

Then(/^I see this summary:$/) do |table|
    table.hashes.each do |row|
      item = find('.balance-item', text: /#{row['Broadcast']}/)
      within(item) do
        expect(find('.reviews')).to have_text(row['Reviews'])
        expect(find('.satisfaction')).to have_text(row['Satisfaction'])
        expect(find('.average')).to have_text(row['Average'])
        expect(find('.total')).to have_text(row['Total'])
      end
    end
end

Given(/^I have (\d+) broadcasts in my database$/) do |number|
  description = 'I am displayed on fully visible decision cards'
  create_list(:broadcast, number.to_i, description: description)
end

Then(/^I see the buttons to click 'Yes' or 'No' only once, respectively$/) do
  expect(page).to have_css('.decision-card-action.positive', count: 1)
  expect(page).to have_css('.decision-card-action.neutral', count: 1)
end

Then(/^only the first card on the stack is displayed$/) do
  expect(page).to have_css('.decision-card .description', count: 1)
  description = find('.decision-card .description')
  expect(description).to have_text 'I am displayed on fully visible decision cards'
  expect(page).to have_css('.decision-card', count: 1) # only one card initially
end

Then(/^all of a sudden, there are more broadcasts again$/) do
  expect(page).to have_css('.decision-card', count: 1)
end

Given(/^there are (\d+) registered users$/) do |number|
  number.to_i.times { create(:user) }
end

Given(/^every user wants to pay (\d+) broadcasts each with €(\d+\.?\d*) each$/) do |number, amount|
  User.find_each do |user|
    number.to_i.times { create(:selection, user: user, amount: amount.to_f) }
  end
end

Then(/^I can see these numbers:$/) do |table|
  row = table.hashes.first
  expect(page).to have_css('.statistics.registered-users', text: row['Registered users'])
  expect(page).to have_css('.statistics.reviews', text: row['Reviews'])
  expect(page).to have_css('.statistics.money-assigned', text: row['Money assigned'])
end

Then(/^there is a link that brings me to the balances page$/) do
  click_on 'Balances per broadcast'
  expect(page).to have_css('.balances')
  expect(current_path).to eq '/balances'
end

When(/^I click 'Next' when I am asked if I want to pay for the broadcast$/) do
  expect(page).to have_css('.decision-card-action.neutral')
  find('.decision-card-action.neutral').click
end

When(/^the decision card has disappeared$/) do
  wait_for_transition('.decision-card')
end

Then(/^I can still click on the 'Back' button$/) do
  expect(page).to have_css('.back.button')
  find('.back.button').click
end

Then(/^click 'Yes, I do!'$/) do
  expect(page).to have_css('.decision-card-action.positive', text: /Yes, I do!/)
  find('.decision-card-action.positive', text: /Yes, I do!/).click
end

Then(/^the decision card turns green$/) do
  wait_for_transition('.decision-card')
  expect(page).to have_css('.decision-card.green')
end

Then(/^in the database my response is saved as 'positive'$/) do
  wait_for_ajax
  expect(Selection.count).to eq 1
  expect(Selection.first.response).to eq 'positive'
end

Given(/^I really like a broadcast called "([^"]*)"$/) do |title|
  @favourite_broadcast
end

Given(/^I have reviewed all broadcasts already$/) do
  expect(@user.selections.count).to eq Broadcast.count
end

Given(/^the form to create a new broadcast is there$/) do
  expect(page).to have_css('#broadcast-form')
end

When(/^I enter the title "([^"]*)" with the following description:$/) do |title, description|
  @title, @description = title, description
  fill_in 'title', with: title
  fill_in 'description', with: description
end

Then(/^a new broadcast was stored in the database with the data above$/) do
 broadcast = Broadcast.last
 expect(broadcast.title).to eq @title
 expect(broadcast.description).to eq @description
end

Then(/^when I click on "([^"]*)" I can choose that broadcast$/) do |button|
  click_on button
  expect(page).to have_text(@favourite_broadcast)
end

Given(/^there are (\d+) broadcasts in the database$/) do |number|
  number.to_i.times { create(:broadcast) }
end

When(/^I click 'Yes' three times in a row$/) do
  3.times do
    expect(page).to have_css('.decision-card-action.positive')
    find('.decision-card-action.positive').click
    wait_for_transition '.decision-card'
  end
end

Then(/^message pops up, telling me I could reload more broadcasts$/) do
  within('.help-message') do
    expect(page).to have_text 'You can add more broadcasts to the list'
  end
end

Then(/^then, the message is replaced with another one, requesting me this:$/) do |string|
  within('.help-message') do
    expect(page).to have_text string
  end
end

Then(/^I see a form to enter a title and a description$/) do
  expect(page).to have_field('title')
  expect(page).to have_field('description')
end

Given(/^one broadcast with title "([^"]*)"$/) do |title|
  @broadcast = create(:broadcast, title: title)
end

Given(/^do not see the desired broadcast by coincidence$/) do
  Timeout::timeout(5) do
    expect(page).to have_css('.decision-card')
    its_there = find('.decision-card').text.include? @broadcast.title
    while its_there
      page.reset!
      visit '/decide'
      expect(page).to have_css('.decision-card')
      its_there = find('.decision-card').text.include? @broadcast.title
    end
  end
end

When(/^I search for "([^"]*)"$/) do |query|
  fill_in 'search', with: query
  @query = query
  click_on 'submit-search'
end

Then(/^there is exactly one search result$/) do
  expect(page).to have_text("1 result")
end

Then(/^the displayed broadcast has the title:$/) do |title|
  expect(page).to have_css '.decision-card'
  within '.decision-card' do
    expect(page).to have_text title
  end
end

Given(/^(\d+) out of (\d+) users want to pay for a show called "([^"]*)"$/) do |positive, total, title|
  @broadcast = create(:broadcast, title: title)
  create_list(:selection, positive.to_i, broadcast: @broadcast, response: :positive)
  neutral = total.to_i - positive.to_i
  create_list(:selection, neutral, broadcast: @broadcast, response: :neutral)
end

Given(/^the total amount collected for this show is €(\d+\.\d+)$/) do |amount|
  average = (amount.to_f / @broadcast.selections.positive.count.to_f)
  @broadcast.selections.positive.each do |s|
    s.amount = average
    s.save
  end
end

Given(/^(\d+) users of the app never voted on this show$/) do |number|
  create_list(:user, number.to_i)
end

Given(/^I get no search results$/) do
  expect(page).to have_text('no result')
end

Given(/^then the broadcast form pops up, encouraging me to create a new one$/) do
  expect(page).to have_css('#broadcast-form')
end

Given(/^I see the input field filled out with the title I searched for$/) do
  expect(page).to have_css('#title')
  expect(find('#title').value).to eq @query
end

When(/^I just hit "([^"]*)"$/) do |button|
  click_on button
end

Then(/^I get an error message$/) do |string|
  string.split('[...]').each do |part|
    expect(page).to have_css('.error.message', text: part.strip)
  end
end

Then(/^because I'm lazy, I just submit the broadcast's official website$/) do |string|
  fill_in 'description', with: string
  click_on 'Create'
end

Then(/^no broadcast was saved to the database$/) do
  expect(Broadcast.count).to eq 0
end

Given(/^yesterday I deselected a broadcast called "([^"]*)"$/) do |title|
  @broadcast = create(:broadcast, title: title)
  create(:selection, user: @user, broadcast: @broadcast, response: :neutral)
end

Given(/^today I learned that it is actually a broadcast that I really like$/) do
 # just documentation
end

When(/^I visit the broadcasts page$/) do
  visit '/broadcasts'
end

When(/^I click on the unimpressed smiley next to "([^"]*)"$/) do |title|
  expect(page).to have_text(title)
  within('.broadcast', {text: /#{title}/}) do
    find('button.reselect').click
  end
end

Then(/^the smiley turns happy$/) do
  within('.broadcast', {text: /#{@broadcast.title}/}) do
    expect(page).to have_css('button.unselect')
  end
end

Then(/^on my invoice, this broadcast shows up suddenly$/) do
  visit '/invoice'
  expect(page).to have_text(@broadcast.title)
end

Then(/^a label indicates the medium 'Radio' on the decision card$/) do
  expect(page).to have_css('.medium-radio')
end

When(/^I want to create a new broadcast$/) do
  visit '/decide'
  expect(page).to have_css('.broadcast-form')
end

When(/^I type in "([^"]*)" and choose "([^"]*)" as medium$/) do |title, medium|
  fill_in 'title', with: title
  select medium, from: 'medium'
end

When(/^I fill in a description and hit submit$/) do
  fill_in 'description', with: ('a' * 50)
  click_on 'Create'
end

Then(/^I see "([^"]*)"$/) do |string|
  expect(page).to have_text(string)
end

Then(/^a new radio broadcast is created in the database$/) do
  expect(Broadcast.count).to eq 1
  expect(Broadcast.first.medium).to eq 'radio'
end

When(/^I click on the tv icon$/) do
  click_on 'filter-by-tv'
end

Then(/^the tv icon is disabled$/) do
  expect(page).to have_css('#filter-by-tv:not(primary)')
end

When(/^I click on the radio icon$/) do
  click_on 'filter-by-radio'
end

Then(/^both radio and tv icons are disabled$/) do
  expect(page).to have_css('#filter-by-tv:not(primary)')
  expect(page).to have_css('#filter-by-radio:not(primary)')
end

Then(/^the only (?:thing|broadcast) I see is "([^"]*)"$/) do |string|
  expect(page).to have_text(string)
end

When(/^I enter "([^"]*)" into the search bar$/) do |string|
  fill_in 'search', with: string
end

When(/^I click on the suggestion "([^"]*)"$/) do |string|
  expect(page).to have_css('.search.filter', text: string)
  find('.search.filter', text: string).click
end

When(/^I click on the filter by medium select box and then on "([^"]*)"$/) do |label|
  expect(page).to have_css('.multiple.selection', text: /Filter by medium/)
  find('.multiple.selection', text: /Filter by medium/).click
  expect(page).to have_css('.item', text: label)
  find('.item', text: label).click
end

When(/^I click on the item "([^"]*)"$/) do |label|
  expect(page).to have_css('.item', text: label)
  find('.item', text: /#{label}/).click
end

Given(/^I reviewed the broadcast "([^"]*)" with this description:$/) do |title, description|
  @broadcast = create(:broadcast, title: title, description: description)
  create(:selection, broadcast: @broadcast, user: @user)
end

When(/^I click the edit button next to the title "([^"]*)"$/) do |arg1|
  click_on 'Edit'
end

When(/^I change the description to:$/) do |string|
  @better_description = string
  fill_in 'description', with: @better_description
end

Then(/^this better description was saved$/) do
  @broadcast.reload
  expect(@broadcast.description).to eq @better_description
end

