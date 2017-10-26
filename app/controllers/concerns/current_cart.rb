module CurrentCart
  private
  def set_cart
    @cart = Cart.find(sesson[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart_id
  end
end
