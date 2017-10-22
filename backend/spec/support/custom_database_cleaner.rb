module CustomDatabaseCleaner
  def clean_database!
    [Impression, User, Schedule, Broadcast, Station, Medium].each(&:destroy_all)
    Impression::History.delete_all
  end
end
