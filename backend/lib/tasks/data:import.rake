namespace :data do
  desc 'Import broadcasts from /tmp/import'
  task import: [:environment] do
    require 'csv'

    Broadcast.transaction do
      CSV.foreach("#{Rails.root}/tmp/import/broadcasts.csv", headers: true) do |b|
        broadcast = Broadcast.new(b.to_hash)
        broadcast.save!
      end
    end
  end
end
