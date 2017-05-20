namespace :db do
  desc 'Correction of sequences id'
  task correction_seq_id: :environment do
    ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.reset_pk_sequence!(t) }
  end
end
