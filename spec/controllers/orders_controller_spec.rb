require 'rails_helper'

describe OrdersController do
  before :each do
    user = create(:user)
    session[:user_id] = user.id
  end

  it 'includes CurrentCart' do
    expect(OrdersController.ancestors.include? CurrentCart).to eq(true)
  end

  describe 'GET #index' do
    it 'populates an array of all orders' do
      order1 = create(:order, name: "Buyer 1")
      order2 = create(:order, name: "Buyer 2")
      get :index
      expect(assigns(:orders)).to match_array([order1, order2])
    end

    it 'renders the :index template' do
      get :index
      expect(response).to render_template(:index)
    end
    
    context 'with searching parameters' do
      before :each do
        @food1 = create(:food, price: 25000)
        @order1 = create(:order, name: 'Ajeng', email: 'ajeng.bas@ggg.mmm', address: 'Privet Drive 4')
        @line_item1 = create(:line_item, food: @food1, quantity: 1, order: @order1)
        @order1.total_price = @order1.set_total_price
        @order1.save

        @order2 = create(:order, name: 'Panggah', email: 'panggah.bas@ggg.mmm', address: 'Privet Drive 4A')
        @line_item2 = create(:line_item, food: @food1, quantity: 3, order: @order2)
        @order2.total_price = @order2.set_total_price
        @order2.save
      end

      it 'populates an array of orders containing name param' do
        get :index, params: { order: { name: 'ajeng' } }
        expect(assigns(:orders)).to match_array([@order1])
      end

      it 'populates an array of orders containing address param' do
        get :index, params: { order: { address: '4A' } }
        expect(assigns(:orders)).to match_array([@order2])
      end

      it 'populates an array of orders containing email param' do
        get :index, params: { order: { email: 'bas@ggg' } }
        expect(assigns(:orders)).to match_array([@order1, @order2])
      end

      it 'populates an array of orders with total_price >= params' do
        get :index, params: { order: { min_total_price: 40000 } }
        expect(assigns(:orders)).to match_array([@order2])
      end

      it 'populates an array of foods with total_price <= params' do
        get :index, params: { order: { max_total_price: 25000 } }
        expect(assigns(:orders)).to match_array([@order1])
      end

      it 'populates an array of foods with combination of search params' do
        get :index, params: { order: { email: 'ajeng', address: '4A' } }
        expect(assigns(:orders)).to match_array([])
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested order to @order' do
      order = create(:order)
      get :show, params: { id: order }
      expect(assigns(:order)).to eq(order)
    end

    it 'renders the :show template' do
      order = create(:order)
      get :show, params: { id: order }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    context 'With non empty cart' do
      before :each do
        @cart = create(:cart)
        session[:cart_id] = @cart.id
        @line_item = create(:line_item, cart: @cart)
      end

      it 'assigns a new Order to @order' do
        get :new
        expect(assigns(:order)).to be_a_new(Order)
      end

      it 'renders the :new template' do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context 'With empty cart' do
      before :each do
        @cart = create(:cart)
        session[:cart_id] = @cart.id
      end

      it 'redirects to the store index page' do
        get :new
        expect(:response).to redirect_to(store_index_path)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested order to @order' do
      order = create(:order)
      get :edit, params: { id: order }
      expect(assigns(:order)).to eq(order)
    end

    it 'renders the :edit template' do
      order = create(:order)
      get :edit, params: { id: order }
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST create' do
    before :each do
      @cart = create(:cart)
      session[:cart_id] = @cart.id
      @line_item = create(:line_item, cart: @cart)
    end
    
    context 'with valid attributes' do
      it 'saves the new order in the database' do
        expect {
          post :create, params: { order: attributes_for(:order) }
        }.to change(Order, :count).by(1)
      end

      it 'adds line_items to order' do
        post :create, params: { order: attributes_for(:order) }
        expect(assigns(:order).line_items.count).to be(1)
      end

      it "destroys session's cart" do
        expect {
          post :create, params: { order: attributes_for(:order)}
        }.to change(Cart, :count).by(-1)
      end

      it "removes the cart from session's params" do
        post :create, params: { order: attributes_for(:order) }
        expect(session[:cart_id]).to be(nil)
      end

      it 'sends order confirmation email' do
        post :create, params: { order: attributes_for(:order) }
        expect{
          OrderMailer.received(assigns(:order)).deliver
        }.to change{ ActionMailer::Base.deliveries.count }.by(1)
      end

      # it 'redirects to store index page' do
      #   post :create, params: { order: attributes_for(:order) }
      #   expect(response).to redirect_to(store_index_path)
      # end

      it 'redirects to order if logged in' do
        post :create, params: { order: attributes_for(:order) }
        expect(response).to redirect_to(assigns(:order))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new order in the database' do
        expect{
          post :create, params: { order: attributes_for(:invalid_order) }
        }.not_to change(Order, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { order: attributes_for(:invalid_order) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @order = create(:order)
    end

    context 'With valid attributes' do
      it 'locates the requested @order' do
        patch :update, params: { id: @order, order: attributes_for(:order) }
        expect(assigns(:order)).to eq(@order)
      end

      it "changes @order's attributes" do
        patch :update, params: { id: @order, order: attributes_for(:order, name: 'Update name') }
        @order.reload
        expect(@order.name).to eq('Update name')
      end

      it 'redirect to the order' do
        patch :update, params: { id: @order, order: attributes_for(:order) }
        expect(response).to redirect_to(@order)
      end
    end

    context 'with invalid attributes' do
      it "does not change order's attributes" do
        patch :update, params: { id: @order, order: attributes_for(:order, name: nil) }
        @order.reload
        expect(@order.name).not_to be(nil)
      end

      it 're-renders the :edit template' do
        patch :update, params: { id: @order, order: attributes_for(:order, name: nil) }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @order = create(:order)
    end
    
    it 'deletes order from the database' do
      expect{
        delete :destroy, params: { id: @order }
      }.to change(Order, :count).by(-1)
    end

    it 'redirects to order#index' do
      delete :destroy, params: { id: @order }
      expect(response).to redirect_to(orders_path)
    end
  end
end
