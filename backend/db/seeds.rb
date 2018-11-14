# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# avoid after_commit error when creating broadcasts
Scenic.database.refresh_materialized_view(:statistic_broadcasts, cascade: false)

tv    = Medium.create!(id: 0, name_de: 'TV', name_en: 'TV')
radio = Medium.create!(id: 1, name_de: 'Radio', name_en: 'Radio')
Medium.create!(id: 2, name_de: 'Sonstige', name_en: 'Other')
Medium.create!(id: 3, name_de: 'Online', name_en: 'Online')
freeradio = Medium.create!(id: 4, name_de: 'Freies Radio', name_en: 'Free radio')

das_erste     = Station.create!(name: 'Das Erste', medium: tv)
wdr_fernsehen = Station.create!(name: 'WDR Fernsehen', medium: tv)
zdf           = Station.create!(name: 'ZDF', medium: tv)
einslive      = Station.create!(name: '1Live', medium: radio)
fritz         = Station.create!(name: 'Fritz', medium: radio)
wueste_welle  = Station.create!(name: 'Wüste Welle', medium: freeradio)

Broadcast.create!(
  title: 'Quarks & Co',
  stations: [wdr_fernsehen],
  medium: tv,
  description: 'Bei Quarks & Co soll Wissenschaft unterhalten. Deshalb fährt die Sendung alles auf, was das Fernsehen zu bieten hat: spannende Experimente, abenteuerliche Selbstversuche, überzeugende Grafiken und faszinierende Computeranimationen.'
)
Broadcast.create!(
  title: 'Tagesschau',
  stations: [das_erste],
  medium: tv,
  description: 'Die Nachrichtensendung im Ersten.'
)
Broadcast.create!(
  title: 'heute journal',
  stations: [zdf],
  medium: tv,
  description: 'Das heute-journal: politische Berichte, scharfsinnige Analysen und verständliche Erklärungen.'
)
Broadcast.create!(
  title: 'Die Sendung mit der Maus',
  stations: [wdr_fernsehen],
  medium: tv,
  description: 'Die Sendung mit der Maus ... und dem Elefanten.'
)
Broadcast.create!(
  title: 'Der beste Tag der Welt',
  stations: [einslive],
  medium: radio,
  description: 'Der coolste Anchorman der Welt, William Cohn, zelebriert tagesaktuelle Themen, historische Ereignisse oder schlichten Mumpitz. Hauptsache gnadenlos, schräg und böse! Denn jeder Tag ist der beste Tag der Welt.'
)
Broadcast.create!(
  title: 'SOUNDGARDEN',
  stations: [fritz],
  medium: radio,
  description: 'Von 20 bis 22 Uhr steht bei uns jeder Abend unter einem anderen musikalischen Motto. Euch erwarten Klassiker und aktuelle Neuerscheinungen aus den verschiedensten Genres - von Elektro bis Rock, von Urban bis Indie.'
)
Broadcast.create!(
  title: 'Info-Magazin',
  stations: [wueste_welle],
  medium: freeradio,
  description: 'Aktuell und hintergründig-lokal und global – mit Eigenbeiträgen und den besten Politik-Beiträgen der Freien Radios sowie tagesaktuellen Veranstaltungshinweisen.'
)

users = (1..5).collect do |i|
  User.create(
    # avoid unnecessary geocode user job
    latitude: rand(-90.000000000...90.000000000),
    longitude: rand(-180.000000000...180.000000000),
    email: "test_user#{i}@example.org"
  )
end

# create a random set of impressions
Broadcast.find_each do |broadcast|
  users.each do |user|
    amount = nil # default
    response = %i[positive neutral].sample
    if response == :positive
      remaining_amount = Impression::BUDGET - user.impressions.sum(:amount)
      amount = rand(0.0..remaining_amount.to_f)
    end
    Impression.create(user: user, response: response, amount: amount, broadcast: broadcast)
  end
end
Similarity.compute_all(threshold: 0.1, minimum_supporters: ComputeSimilaritiesWorker.minimum_supporters)

# Add impression seed data
# Add impression seed data
Impression.transaction do
  @t0 = 8.months.ago
  @t1 = 7.months.ago
  @t2 = 6.months.ago
  @t3 = 5.months.ago
  @t4 = 4.months.ago
  @t5 = 3.months.ago
  @t6 = 2.months.ago
  @t7 = 1.months.ago
  @t8 = 0.months.ago
  data = [
    { response: :positive, amount: 2.0, from: (@t2 - 1.second), to: nil },
    { response: :positive, amount: nil, from: (@t3 - 1.second), to: nil },
    { response: :positive, amount: 7.0, from: (@t4 - 1.second), to: nil },
    { response: :neutral,  amount: nil, from: (@t5 - 1.second), to: nil },
    { response: :positive, amount: 6.0, from: (@t6 - 1.second), to: nil },
    { response: :positive, amount: 0.0, from: (@t7 - 1.second), to: (@t8 - 1.second) }
  ]
  broadcast_array = [
    { title: 'b', id: 4711, created_at: @t1, updated_at: @t1 },
    { title: 'c', id: 4712, created_at: @t2, updated_at: @t2 },
    { title: 'd', id: 4713, created_at: @t3, updated_at: @t3 },
    { title: 'e', id: 4714, created_at: @t4, updated_at: @t4 },
    { title: 'f', id: 4715, created_at: @t5, updated_at: @t5 },
    { title: 'g', id: 4716, created_at: @t6, updated_at: @t6 }
  ]

  broadcast_array.each do |broadcast|
    new_broadcast = FactoryBot.create(:broadcast, title: broadcast[:title], id: broadcast[:id], medium: tv, created_at: broadcast[:created_at], updated_at: broadcast[:updated_at])
    data.each do |d|
      impression = FactoryBot.create(:impression, broadcast: new_broadcast, response: d[:response], amount: d[:amount])
      h = impression.history.first
      h.class.amend_period!(h.hid, d[:from], d[:to])
    end

    last_impression = Impression.last
    last_impression.amount = 10.0
    last_impression.save!
    h = last_impression.history.last
    h.class.amend_period!(h.hid, @t8 - 1.second, nil)
  end
end
