# coding: utf-8
feature_directory = Pathname.new(__FILE__).join('../..')
def sanitize_amount(amount)
  begin
    Float(amount.gsub('€',''))
  rescue
    nil
  end
end

def login
  stub_jwt(@user)
  click_on 'Log in'
end

Given(/^I am logged in$/) do
  visit '/'
  @user = create(:user)
  login
end

Given(/^(?:I|we) have (?:these|this) broadcast(?:s)? in (?:my|our) database:$/) do |table|
  table.hashes.each do |row|
    attributes = { title: row['Title'] }
    attributes[:id] = row['ID'] if row['ID']
    attributes[:created_at] = row['Created at'] || Date.today
    attributes[:description] = row['Description'] if row['Description']
    attributes[:image_url] = row['Image url']
    attributes[:broadcast_url] = row['Broadcast url']
    if row['Medium']
      medium = Medium.all.find{|m| m.name == row['Medium'] } || create(:medium, name_de: row['Medium'], name_en: row['Medium'])
      attributes[:medium] = medium
    end
    if row['Station']
      stations = [Station.find_by(name: row['Station']) || create(:station, name: row['Station'])]
      attributes[:stations] = stations
    end
    broadcast = create(:broadcast, attributes)

    # pretend it was updated that date
    broadcast.update_column(:updated_at, row['Updated at']) if row['Updated at']
  end
end

When(/^I visit the landing page$/) do
  visit '/'
  expect(page).to have_css('.ui.main.container')
end

Then(/^I can read:$/) do |string|
  actual = page.text.gsub("\n", ' ')
  expected = string.gsub("\n", ' ')
  expect(actual).to include(expected)
end

When(/^(?:then |when )?I click on "([^"]*)"/) do |string|
  click_on string
end

Then(/^a new user was created in the database$/) do
  expect(User.count).to eq 1
end

Given(/^I have signed up two months ago/) do
  @email = 'legacy_user@example.org'
  @user = create(:user, email: @email)
end

Then(/^my login was successful$/) do
  wait_for_ajax
  expect(page).to have_text('Log out')
end

When(/^I visit the find broadcasts page$/) do
  visit '/find-broadcasts'
  expect(page).to have_css('.find-broadcasts-page')
end

When(/^I support ([^"]*) and ([^"]*) but not ([^"]*)$/) do |title1, title2, title3|
  expect(page).to have_text(title1)
  expect(page).to have_text(title2)
  expect(page).to have_text(title3)
  [title1, title2].each do |title|
    within('.decision-card', text: title) do
      click_on 'Support'
    end
  end
  click_on 'Next'
end

Then(/^my responses in the database are like this:$/) do |table|
  wait_for_ajax
  table.hashes.each do |row|
    broadcast = Broadcast.find_by(title: row['Title'])
    impression = broadcast.impressions.first
    expect(impression.user_id).to eq @user.id
    expect(impression.response).to eq row['Response']
  end
end

Given(/^I want to give money to each of these broadcasts:$/) do |table|
  table.hashes.each do |row|
    b = create(:broadcast, title: row['Title'])
    create(:impression, user: @user, broadcast: b)
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

Then(/^also in the database all impressions have the same amount of "([^"]*)"$/) do |amount|
  amounts = Impression.pluck(:amount)
  expect(amounts.all? {|a| a == amount.to_f}).to be_truthy
end

Given(/^my broadcasts look like this:$/) do |table|
  table.hashes.each do |row|
    title = row['Title']
    amount = sanitize_amount(row['Amount']) if row['Amount']
    fixed = !! (row['Fixed'] =~ /yes/i)
    if row['Support']
      response = (row['Support'] =~ /yes/i) ? :positive : :neutral
    else
      response = :positive
    end
    broadcast = Broadcast.find_by(title: title) || create(:broadcast, title: title)
    create(:impression,
           user: @user,
           broadcast: broadcast,
           response: response,
           amount: amount,
           fixed: fixed
          )
  end
end

When(/^I look at my broadcasts/) do
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

Then(/^my updated broadcasts look like this:$/) do |table|
  wait_for_ajax
  check_invoice(table)
end

Then(/^my response to "([^"]*)" is listed in the database as "([^"]*)"$/) do |title, response|
  impression = @user.impressions.find {|s| s.broadcast.title == title }
  expect(impression.response).to eq response
end


def change_amount(title, amount)
  invoice_table = find('#invoice-table')
  scroll_to(invoice_table)
  invoice_item = find('.invoice-item', text: /#{title}/)
  within(invoice_item) do
    find('.ember-inline-edit').click
    find('input').set(amount)
    find('.ember-inline-edit-save').click
  end
end

When(/^I change the amount of "([^"]*)" to "([^"]*)" euros$/) do |title, amount|
  change_amount(title, amount)
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

When(/^I click on the german flag$/) do
  click_on 'Deutsch'
end

Then(/^I(?: can)? see the "([^"]*)" menu item$/) do |label|
  expect(page).to have_css('.button', text: label)
end

Given(/^I see a medium called "([^"]*)"$/) do |medium|
  within('.broadcast-search') do
    find('.ui.dropdown').click
    expect(page).to have_text(medium)
  end
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
  impression = @user.impressions.find {|s| s.broadcast.title ==  title }
  impression.reload
  if value == 'true'
    expect(impression).to be_fixed
  else
    expect(impression).not_to be_fixed
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
      user = create(:user, email: row['Email'])
    end
    create(:impression,
           broadcast: broadcast,
           user: user,
           response: :positive,
           amount: sanitize_amount(row['Amount']))
  end
end

When(/^I visit the public statistics page$/) do
  visit '/statistics'
end

Then(/^I see this summary:$/) do |table|
  table.hashes.each do |row|
    item = find('.statistic-item', text: /#{row['Broadcast']}/)
    within(item) do
      expect(find('.impressions')).to have_text(row['Impressions'])
      expect(find('.approval')).to have_text(row['Approval'])
      expect(find('.average')).to have_text(row['Average'])
      expect(find('.total')).to have_text(row['Total'])
    end
  end
end

Given(/^I have (\d+) broadcasts in my database$/) do |number|
  description = 'I am displayed on fully visible decision cards'
  create_list(:broadcast, number.to_i, description: description)
end

Given(/^there are (\d+) registered users$/) do |number|
  number.to_i.times { create(:user) }
end

Given(/^every user wants to pay (\d+) broadcasts each with €(\d+\.?\d*) each$/) do |number, amount|
  User.find_each do |user|
    number.to_i.times { create(:impression, user: user, amount: amount.to_f) }
  end
end

Then(/^I can see these numbers:$/) do |table|
  row = table.hashes.first
  expect(page).to have_css('.statistics.registered-users', text: row['Registered users'])
  expect(page).to have_css('.statistics.impressions', text: row['Impressions'])
  expect(page).to have_css('.statistics.money-assigned', text: row['Already assigned'])
end

Then(/^there is a link that brings me to the statistics page$/) do
  scroll_to(find('a[href="/statistics"]', text: 'Statistics per broadcast'))
  click_on 'Statistics per broadcast'
  expect(page).to have_css('.statistics')
  expect(current_path).to eq '/statistics'
end

Then(/^I have one positive response in the database$/) do
  wait_for_ajax
  expect(Impression.count).to be > 1 # more than just once
  expect(Impression.positive.count).to eq 1
end

Given(/^I really like a broadcast called "([^"]*)"$/) do |title|
  # just doc
end

Given(/^I have reviewed all broadcasts already$/) do
  expect(@user.impressions.count).to eq Broadcast.count
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

Given(/^there are (\d+) broadcasts in the database$/) do |number|
  number.to_i.times { create(:broadcast) }
end

Then(/^I see a form to enter a title and a description$/) do
  expect(page).to have_field('title')
  expect(page).to have_field('description')
end

Given(/^(?:I have )?one broadcast with title "([^"]*)"$/) do |title|
  @broadcast = create(:broadcast, title: title)
end

When(/^I search for "([^"]*)"$/) do |query|
  fill_in 'search', with: query
  @query = query
  click_on 'submit-search'
end

Then(/^there is exactly one search result$/) do
  expect(page).to have_text("1 result")
end

Then("there are exactly {int} search results") do |count|
  expect(page).to have_text("#{count} result")
end

Then(/^the only displayed broadcast has the title:$/) do |title|
  expect(page).to have_css('.decision-card', count: 1)
  within '.decision-card' do
    expect(page).to have_text title
  end
end

Given(/^(\d+) out of (\d+) users want to pay for a show called "([^"]*)"$/) do |positive, total, title|
  @broadcast = create(:broadcast, title: title)
  create_list(:impression, positive.to_i, broadcast: @broadcast, response: :positive)
  neutral = total.to_i - positive.to_i
  create_list(:impression, neutral, broadcast: @broadcast, response: :neutral)
end

Given(/^the total amount collected for this show is €(\d+\.\d+)$/) do |amount|
  average = (amount.to_f / @broadcast.impressions.positive.count.to_f)
  @broadcast.impressions.positive.each do |s|
    s.amount = average
    s.save
  end
end

Given(/^(\d+) users of the app never viewed this show$/) do |number|
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
  scroll_to(find('button[type="submit"]', text: 'Create'))
  click_on 'Create'
end

Then(/^no broadcast was saved to the database$/) do
  expect(Broadcast.count).to eq 0
end

Given(/^yesterday I deselected a broadcast called "([^"]*)"$/) do |title|
  @broadcast = create(:broadcast, title: title)
  create(:impression, user: @user, broadcast: @broadcast, response: :neutral)
end

Given(/^today I learned that it is actually a broadcast that I really like$/) do
  # just documentation
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
  expect(page).to have_css('.meta', text: 'Radio')
end

When(/^I want to create a new broadcast$/) do
  visit '/find-broadcasts'
  expect(page).to have_css('.broadcast-form')
end

When(/^I type in "([^"]*)" and choose "([^"]*)" as medium$/) do |title, medium|
  fill_in 'title', with: title
  find('.selection', text: 'Select medium').click
  find('.item:not(.blank)', text: medium).click
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
  expect(Broadcast.first.medium.name).to eq 'Radio'
end

Then(/^the only (?:thing|broadcast) I see is "([^"]*)"$/) do |string|
  expect(page).to have_text(string)
end

def filter_by_medium(label)
  expect(page).to have_css('.selection', text: /Filter by medium/)
  find('.selection', text: /Filter by medium/).click
  expect(page).to have_css('.item:not(.blank)', text: label)
  find('.item:not(.blank)', text: label).click
end

When(/^I filter by medium "([^"]*)"$/) do |label|
  filter_by_medium(label)
end

Given(/^I reviewed the broadcast "([^"]*)" with this description:$/) do |title, description|
  @broadcast = create(:broadcast, title: title, description: description)
  create(:impression, broadcast: @broadcast, user: @user)
end

When(/^I click the edit button next to the title "([^"]*)"$/) do |title|
  within('tr.broadcast', text: title) do
    find('button.edit').click
  end
  wait_for_transition('.broadcast-form-modal')
end

When(/^I change the description to:$/) do |string|
  @better_description = string
  fill_in 'description', with: @better_description
end

Then(/^this better description was saved$/) do
  wait_for_ajax
  @broadcast.reload
  expect(@broadcast.description).to eq @better_description
end

def support_some_broadcasts(number)
  create_list(:broadcast, number)
  visit '/find-broadcasts'
  @responses = number
  @responses.times do
    expect(page).to have_css('.decision-card-action.positive')
    find('.decision-card-action.positive').click
    wait_for_transition('.decision-card')
  end
end

Given(/^the statistics look like this:$/) do |table|
  table.hashes.each do |row|
    n_impressions = row['Reviews'].to_i
    approval = row['Approval'].to_f/100.0
    n_positive = approval*n_impressions
    average_amount = sanitize_amount(row['Total'])/n_positive
    n_neutral = (1.0 - approval)*n_impressions

    tv = Medium.find_by(id: 0) || create(:medium, id: 0, name: 'TV')
    stations = if row['Station']
                [Station.find_by(name: row['Station']) || create(:station, name: row['Station'], medium: tv)]
              else
                []
              end

    broadcast = create(:broadcast, title: row['Broadcast'], medium: tv, stations: stations)
    create_list(:impression, n_positive.to_i,
                broadcast: broadcast,
                response: :positive,
                amount: average_amount)
    create_list(:impression, n_neutral.to_i,
                broadcast: broadcast,
                response: :neutral)
  end
end

When(/^I click on the header "([^"]*)" once$/) do |header|
  find('th', text: header).click
end

Then(/^the table is sorted ascending by column "([^"]*)"$/) do |header|
  expect(page).to have_css('th.sorted.ascending', text: header)
end

Then(/^the table is sorted descending by column "([^"]*)"$/) do |header|
  expect(page).to have_css('th.sorted.descending', text: header)
end

Then(/^there are (\d+) remaining broadcasts, namely "([^"]*)" and "([^"]*)"$/) do |number, title1, title2|
  expect(page).to have_text("#{number} results")
  expect(page).to have_text(title1)
  expect(page).to have_text(title2)
end

def filter_by_station(label)
  find('.selection', text: 'Filter by station').click
  expect(page).to have_css('.item:not(.blank)', text: label)
  find('.item:not(blank)', text: label).click
end

Then(/^the only station to choose from is "([^"]*)"$/) do |station|
  find('.selection', text: 'Filter by station').click
  within('.menu.visible') do
    expect(page).to have_css('.item:not(.blank)', text: station)
    expect(page).to have_css('.item:not(.blank)', count: 1)
  end
end

Given(/^we have (\d+) broadcasts in our database$/) do |count|
  create_list(:broadcast, count.to_i)
end

Then(/^there are no stations to choose from$/) do
  expect(page).not_to have_css('.selections', text: 'Filter by station')
end

Given(/^we have these media:$/) do |table|
  table.hashes.each do |row|
    create(:medium,
           name_en: (row['Medium'] || row['Medium_en']),
           name_de: (row['Medium'] || row['Medium_de']),
          )
  end
end

When(/^I choose "([^"]*)" from the list of available media$/) do |medium|
  find('.selection', text: 'Select medium').click
  find('.item:not(.blank)', text: medium).click
end

Given(/^we have these stations(?: in our database)?:$/) do |table|
  table.hashes.each do |row|
    medium = Medium.all.find{|m| m.name == row['Medium'] } || create(:medium, name_de: row['Medium'], name_en: row['Medium'])
    create(:station, name: row['Station'], medium: medium)
  end
end

When(/^I choose "([^"]*)" from the list of "([^"]*)" stations$/) do |station, medium|
  filter_by_medium(medium)
  filter_by_station(station)
end

Given(/^there is a(?:nother)? broadcast called "([^"]*)"/) do |title|
  broadcast = create(:broadcast, title: title)
end

Then(/^I see "([^"]*)".* but I don't see "([^"]*)"$/) do |see, dontsee|
  expect(page).to have_text(see)
  expect(page).not_to have_text(dontsee)
end

Given(/^I want to create a new broadcast that does not exist yet$/) do
  expect(Broadcast.count).to eq 0
  # if there are no broadcasts, a visit of /find-broadcasts will open up the broadcast form

  visit '/find-broadcasts'
  expect(page).to have_css('#broadcast-form')
end

When(/^I enter the following data:$/) do |table|
  row = table.hashes.first
  @title = row['Title']
  @description = row['Description']
  @medium_name = row['Medium']
  @station_name = row['Station']
  fill_in 'title', with: @title
  fill_in 'description', with: @description
  find('.selection', text: 'Select medium').click
  find('.item:not(.blank)', text: @medium_name).click
  expect(page).to have_css('.selection', text: 'Select station')
  find('.selection', text: 'Select station').click
  find('.item:not(.blank)', text: @station_name).click
end

Then(/^the created broadcast has got the exact data from above$/) do
  broadcast = Broadcast.last
  expect(broadcast.title).to eq @title
  expect(broadcast.description).to eq @description
  expect(broadcast.stations.first.name).to eq @station_name
  expect(broadcast.medium.name).to eq @medium_name
end

When(/^I click on the stations dropdown menu$/) do
  find('.selection', text: 'Filter by station').click
end

Then(/^the stations are ordered like this:$/) do |table|
  within('.filter-stations-field') do
    items = all('.item:not(.blank)').map{|item| item.text.gsub("\n", ' ')}
    expect(items).to eq(table.rows.flatten)
  end
end

Then(/^the results are ordered like this:$/) do |table|
  expect(all('.decision-card .title').map(&:text)).to eq(table.rows.flatten)
end

Given(/^we have some more stations:$/) do |table|
  table.hashes.each do |row|
    medium = Medium.all.find{|m| m.name == row['Medium'] } || create(:medium, name_de: row['Medium'], name_en: row['Medium'])
    station = create(:station, name: row['Station'], medium: medium)
    create_list(:broadcast, row['#Broadcasts'].to_i, stations: [station], medium: medium)
  end
end

Then(/^I see that "([^"]*)" is aired on a "([^"]*)" station called "([^"]*)"$/) do |title, medium, station|
  expect(page).to have_css('.decision-card', count: 1)
  expect(page).to have_css('.decision-card .header', text: title)
  expect(page).to have_css('.decision-card .meta', text: medium)
  expect(page).to have_css('.decision-card .meta', text: station)
end

Then(/^no other account was created/) do
  expect(User.count).to eq 1
  visit '/'
  expect(find('.registered-users')).to have_text('1')
end

Given(/^there is no user in the database$/) do
  expect(User.count).to eq 0
end

When(/^I sign up$/) do
  @user = build(:user) # don't create
  stub_jwt(@user)
  expect(User.count).to eq 0
  click_on 'Log in'
end

When(/^I log in with my old credentials$/) do
  login
end

Then(/^there is just one result$/) do
  expect(page).to have_text('1 result')
end

Then(/^when I unselect the station$/) do
  within('.filter-stations-field') do
    find('.selection').click
    find('.item.blank').click
  end
end

Then(/^there are (\d+) results$/) do |number|
  expect(page).to have_text("#{number} result")
end

Then(/^when I unselect the medium$/) do
  within('.filter-media-field') do
    find('.selection').click
    find('.item.blank').click
  end
end

When(/^I click the accordion(?: once again)? on "([^"]*)"$/) do |label|
  find('.accordion .title', text: label).click
end


Given(/^I have (\d+) broadcasts in my database:$/) do |number|
  create_list(:broadcast, number.to_i)
end

When(/^the next page is on$/) do
  expect(page).to have_css('.find-broadcasts-page')
end

When(/^in the database all my responses are 'neutral'$/) do
  wait_for_ajax
  expect(Impression.count).to be > 0
  expect(Impression.all.all? {|s| s.neutral? }).to be true
end

When(/^support the first broadcast$/) do
  wait_for_ajax
  expect(page).to have_css('.find-broadcasts-page')
  within first('.decision-card') do
    click_on 'Support'
  end
end

Then(/^the first broadcast turns green$/) do
  expect(first('.decision-card')).to have_css('button', text: 'Support')
  within first('.decision-card') do
    expect(find('button', text: 'Support')).to have_css('i.red.heart.icon')
  end
end

When(/^I support all broadcasts$/) do
  expect(page).to have_css('.find-broadcasts-page')
  all('.decision-card').each do |node|
    within node do
      click_on 'Support'
    end
  end
  click_on 'Next'
end

Then(/^there are no broadcasts left$/) do
  expect(page).to have_css('.find-broadcasts-page')
  expect(page).not_to have_css('.decision-card')
end

Then(/^then a message pops up, telling me:$/) do |string|
  within('#help-message-new-broadcast') do
    expect(page).to have_text string
  end
end


When(/^I support (\d+) broadcasts? out of (\d+)$/) do |support_times, out_of|
  expect(page).to have_css('.decision-card', count: out_of.to_i)
  all('.decision-card').to_a.slice(0, support_times.to_i).each do |node|
    within node do
      click_on 'Support'
    end
  end
end

Then(/^button to distribute the budget is only a secondary button$/) do
  expect(page).to have_css('.find-broadcasts-navigation-distribute-button.button')
  expect(page).not_to have_css('.find-broadcasts-navigation-distribute-button.primary.button')
end

Then(/^the button to distribute the budget has turned into a primary button$/) do
  expect(page).to have_css('.find-broadcasts-navigation-distribute-button.primary.button')
end

Then("the indicator shows {int} recently supported broadcasts") do |count|
  expect(find('.find-broadcasts-navigation', match: :first)).to have_text(count.to_s)
end

When(/^(?:again, )?I see (\d+) broadcasts to choose from$/) do |number|
  expect(page).to have_css('.decision-card', count: number.to_i)
end

When(/^I see broadcasts in random order$/) do
  random_order = false
  ordered_by_coincidence = 0
  until random_order
    page.evaluate_script("window.location.reload()") # refresh page
    expect(page).to have_css('.decision-card .title')
    titles = all('.decision-card .title').map(&:text)
    random_order = titles != titles.sort_by(&:downcase)
    unless random_order
      ordered_by_coincidence += 1
      fail 'The broadcasts are not in random order' if ordered_by_coincidence > 5
    end
  end
end

Then(/^the drop down menu has excactly these items:$/) do |table|
  find('.selection', text: 'Filter by station').click
  labels = all('.dropdown .item:not(.blank)').map{|item| item.text.gsub("\n", ' ')}
  table.hashes.each_with_index do |row, i|
    expect(labels[i]).to eq row['Label']
  end
end

When(/^I click on the button to order broadcasts in ascending order$/) do
  click_on 'alphabetical_order_ascending' # that would be the id of the button
  wait_for_ajax
end

Then(/^I see broadcasts ascending in order like this:$/) do |table|
  titles = all('.decision-card .title').map(&:text)
  expect(titles).to eq titles.sort_by(&:downcase)
  table.hashes.each_with_index do |row, i|
    expect(row['Title']).to eq titles[i]
  end
end

Then(/^I see only this broadcast and nothing else/) do
  expect(page).to have_css('.title', count: 1)
  expect(page).to have_css('.image', count: 2)
  Broadcast.where.not(title: 'Medienmagazin').find_each do |broadcast|
    expect(page).not_to have_text(broadcast.title)
  end
  expect(page).to have_css('.title.header', text: 'Medienmagazin')
end

When(/^I ask myself: What was "([^"]*)" about\?$/) do |arg1|
  # just documentation
end

Then(/^I can see (?:even more|these) details:$/) do |table|
  table.transpose.hashes.each do |broadcast_details|
    broadcast_details.each do |label, value|
      # change the expecation to match the template of the broadcast page
      expect(page).to have_css(".detail.#{label}", text: /#{Regexp.escape(value)}/)
      # this is just a guess how the html may look like
    end
  end
end

Given(/^there are (\d+) other broadcasts, with a title lexicographically before 'Medienmagazin'$/) do |count|
  count.to_i.times {|i| create(:broadcast, title: "Broadcast ##{i}") }
end

Then(/^if I click on the close icon$/) do
  find('i.remove.icon').click
end

Then(/^I see the broadcast "([^"]*)" among (\d+) other broadcasts again$/) do |title, count|
  expect(page).to have_css('.title', count: count.to_i)
  expect(page).to have_css('.title.header', text: title)
end

When(/^I click on the magnifier symbol next to "([^"]*)"$/) do |title|
  if page.has_css?('.decision-card')
    within('.decision-card', text: title) do
      find('.broadcast-details').click
    end
  else
    within('.broadcast', text: title) do
      find('.broadcast-details').click
    end
  end
end

When(/^I visit my history page$/) do
  visit '/history'
  expect(page).to have_css('.history-page')
end

When(/^I click on the edit button$/) do
  find('.button', text: 'Edit').click
end

When(/^I click on the back button$/) do
  find('.back.button').click
end

Then(/^I am on the find broadcasts page$/) do
  expect(page).to have_text('Choose broadcasts')
  expect(current_path).to eq '/find-broadcasts'
end

When(/^I add "([^"]*)" to the list of stations$/) do |station_name|
  find('.multiple.selection.dropdown').click
  find('.item', text: station_name).click
end

Then(/^the list of stations of "([^"]*)" now consists of:$/) do |title, table|
  broadcast = Broadcast.find_by(title: title)
  station_names = broadcast.stations.map(&:name)
  expect(station_names).to match_array(table.hashes.map {|h| h['Station']})
end

Given("I am on the edit page for Broadcast {string}") do |title|
  broadcast = Broadcast.find_by(title: title)
  visit "/broadcast/#{broadcast.id}/edit"
end

Then("on the broadcast page for {string}, I can see it was updated today") do |title|
  broadcast = Broadcast.find_by(title: title)
  visit "/broadcast/#{broadcast.id}"
  expected_date_string = "Last updated at: #{Time.now.strftime("%-m/%-d/%Y")}"
  expect(find('.detail.updatedAt')).to have_text(expected_date_string)
end

When("I am on the broadcast page for {string}") do |title|
  broadcast = Broadcast.find_by(title: title)
  visit "/broadcast/#{broadcast.id}"
end

Then("I should have a broadcast link {string}") do |url|
  expect(page).to have_css("a[href='#{url}']")
end

Then("I should have an image {string}") do |url|
  expect(page).to have_css("img[src='#{url}']")
end

When("I visit {string}") do |url|
  visit url
end

When("do nothing") do
  # do nothing
end
