module CustomDatabaseCleaner
  def clean_database!
    Impression::History.delete_all
    [Impression, User, Schedule, Broadcast, Station, Medium].each(&:destroy_all)
  end
end
