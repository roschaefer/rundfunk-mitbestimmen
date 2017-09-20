module CustomDatabaseCleaner
  def clean_database!
    [Impression, User, Schedule, Broadcast, Station, Medium].each do |model_class|
      model_class.destroy_all
    end
  end
end
