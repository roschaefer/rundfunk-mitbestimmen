module DatabaseCleaningStrategy
  def without_transactional_fixtures
    self.use_transactional_tests = false

    before(:all) do
      DatabaseCleaner.strategy = :truncation
    end

    yield

    after(:all) do
      DatabaseCleaner.strategy = :transaction
    end
  end
end
