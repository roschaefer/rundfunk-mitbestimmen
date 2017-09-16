# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: 'test@example.org')

tv    = Medium.create!(id: 0, name_de: 'TV', name_en: 'TV')
radio = Medium.create!(id: 1, name_de: 'Radio', name_en: 'Radio')
Medium.create!(id: 2, name_de: 'Sonstige', name_en: 'Other')
Medium.create!(id: 3, name_de: 'Online', name_en: 'Online')

das_erste     = Station.create!(name: 'Das Erste', medium: tv)
wdr_fernsehen = Station.create!(name: 'WDR Fernsehen', medium: tv)
zdf           = Station.create!(name: 'ZDF', medium: tv)
einslive      = Station.create!(name: '1Live', medium: radio)
fritz         = Station.create!(name: 'Fritz', medium: radio)

Broadcast.create!(title: 'Quarks & Co',              stations: [wdr_fernsehen], medium: tv,    description: 'Bei Quarks & Co soll Wissenschaft unterhalten. Deshalb fährt die Sendung alles auf, was das Fernsehen zu bieten hat: spannende Experimente, abenteuerliche Selbstversuche, überzeugende Grafiken und faszinierende Computeranimationen.')
Broadcast.create!(title: 'Tagesschau',               stations: [das_erste],     medium: tv,    description: 'Die Nachrichtensendung im Ersten.')
Broadcast.create!(title: 'heute journal',            stations: [zdf],           medium: tv,    description: 'Das heute-journal: politische Berichte, scharfsinnige Analysen und verständliche Erklärungen.')
Broadcast.create!(title: 'Die Sendung mit der Maus', stations: [wdr_fernsehen], medium: tv,    description: 'Die Sendung mit der Maus ... und dem Elefanten.')
Broadcast.create!(title: 'Der beste Tag der Welt',   stations: [einslive],      medium: radio, description: 'Der coolste Anchorman der Welt, William Cohn, zelebriert tagesaktuelle Themen, historische Ereignisse oder schlichten Mumpitz. Hauptsache gnadenlos, schräg und böse! Denn jeder Tag ist der beste Tag der Welt.')
Broadcast.create!(title: 'SOUNDGARDEN',              stations: [fritz],         medium: radio, description: 'Von 20 bis 22 Uhr steht bei uns jeder Abend unter einem anderen musikalischen Motto. Euch erwarten Klassiker und aktuelle Neuerscheinungen aus den verschiedensten Genres - von Elektro bis Rock, von Urban bis Indie.')
