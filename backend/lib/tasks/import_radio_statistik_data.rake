namespace :data do
  namespace :radiostatistik do
    desc "Import data of radiostatistik.de"
    task import: [:environment] do
      require 'csv'

      # Artist.transaction do
      #   csv = CSV.foreach("#{Rails.root}/tmp/import/radio_interpret.csv", :headers => true, quote_char: '"').each do |row|
      #     attributes = row.to_h
      #     attributes['sublabel'] = nil if attributes['sublabel'] == 'NULL'
      #     attributes['label'] = nil if attributes['sublabel'] == 'NULL'
      #     Artist.create!(attributes)
      #   end
      # end
      Song.transaction do
        csv = CSV.foreach("#{Rails.root}/tmp/import/radio_titel.csv", :headers => true, quote_char: '"').with_index do |row, index|
          break if index >= 5000
          attributes = row.to_h
          attributes = attributes.except('time', 'date')
          Song.create!(attributes)
        end
      end
    end
  end
end
