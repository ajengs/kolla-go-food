class HomeController < ApplicationController
  def hello
    @time = Time.now
  end

  def goodbye
    @tomorrow = Date.today + 1.day
  end
end
