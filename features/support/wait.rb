module Wait
  STEP = 0.1
  def wait_for_ajax
    counter = 0
    while page.evaluate_script("$.active").to_i > 0
      counter += 1
      sleep(Wait::STEP)
      if (Wait::STEP*counter) >= Capybara.default_max_wait_time
        raise "AJAX request took longer than #{Capybara.default_max_wait_time} seconds."
      end
    end
  end
end
World(Wait)
