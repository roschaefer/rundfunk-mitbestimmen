# frozen_string_literal: true

module Scroll
  # other code that prepares capybara to work with selenium

  def scroll_to(element)
    script = <<-JS
      arguments[0].scrollIntoView(true);
    JS

    Capybara.current_session.driver.browser.execute_script(script, element.native)
  end
end
World(Scroll)
