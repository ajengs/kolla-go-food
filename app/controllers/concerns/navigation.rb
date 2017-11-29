module Navigation
  private
  def set_navigations
    @navigations = {
      home: [store_index_path]
    }

    user = User.find(session[:user_id])

    if user.roles.find_by(name: 'administrator')
      @navigations.merge!(
        {
          admin: [admin_path],
          orders: [orders_path],
          categories: [categories_path],
          foods: [foods_path],
          users: [users_path],
          vouchers: [vouchers_path],
          tags: [tags_path],
          restaurants: [restaurants_path]
        }
      )
    end

    @navigations.merge!(
      {
        logout: [logout_path, method: :delete]
      }
    )

  rescue ActiveRecord::RecordNotFound
    @navigations.merge!(
      {
        login: [login_path] 
      }
    )
  end
end
