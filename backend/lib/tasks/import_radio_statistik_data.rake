namespace :data do
  namespace :radiostatistik do
    desc "Import data of radiostatistik.de"
    task import: [:environment] do
      require 'csv'

       Artist.transaction do
         csv = CSV.foreach("#{Rails.root}/tmp/import/radio_interpret.csv", :headers => true, quote_char: '"').each do |row|
           attributes = row.to_h
           attributes['sublabel'] = nil if attributes['sublabel'] == 'NULL'
           attributes['label'] = nil if attributes['sublabel'] == 'NULL'
           Artist.create!(attributes)
         end
       end
      Song.transaction do
        songs = []

        time = Time.now.to_s(:db)
        csv = CSV.foreach("#{Rails.root}/tmp/import/radio_titel.csv", :headers => true, quote_char: '"').with_index do |row, index|
          attr = row.to_h
          attr = attr.except('time', 'date')
          values = %w{id title artist_id aired station}.map {|k| attr[k]}
          songs << "(#{values.map{|v| Song.connection.quote(v)}.join(',')}, '#{time}', '#{time}')"
        end

        if songs.present?
          sql = "INSERT INTO songs (id, title, artist_id, aired, station, created_at, updated_at) VALUES #{songs.join(', ')}"
          ActiveRecord::Base.connection.execute(sql)
        end
      end
    end
  end
end
