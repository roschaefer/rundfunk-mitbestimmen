module CustomDatabaseCleaner
  def clean_database!
    [Impression, User, Schedule, Broadcast, Station, Medium].each(&:destroy_all)
  end
end
