class HomeController < ApplicationController
  def hello
    @time = Time.now
    @users = User.all
  end

  def goodbye
    @tomorrow = Date.today + 1.day
  end

end
