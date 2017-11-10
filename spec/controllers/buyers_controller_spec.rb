require 'rails_helper'

describe BuyersController do
  before :each do
    user = create(:user)
    session[:user_id] = user.id
  end

  describe 'GET #index' do
    it 'populates an array of all buyers' do
      buyer1 = create(:buyer, name: 'Harry Potter')
      buyer2 = create(:buyer, name: 'Ronald Weasley')
      get :index
      expect(assigns(:buyers)).to match_array([buyer1, buyer2])
    end

    it 'renders the :index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested buyer to @buyer' do
      buyer = create(:buyer)
      get :show, params: { id: buyer }
      expect(assigns(:buyer)).to eq(buyer)
    end

    it 'render the :show template' do
      buyer = create(:buyer)
      get :show, params: { id: buyer }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested buyer to @buyer' do
      buyer = create(:buyer)
      get :edit, params: { id: buyer }
      expect(assigns(:buyer)).to eq(buyer)
    end

    it 'render the :edit template' do
      buyer = create(:buyer)
      get :edit, params: { id: buyer }
      expect(response).to render_template(:edit)
    end
  end

  describe 'GET #new' do
    it 'assigns a new buyer to @buyer' do
      get :new
      expect(assigns(:buyer)).to be_a_new(Buyer)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new buyer in the database' do
        expect{
          post :create, params: { buyer: attributes_for(:buyer) }
        }.to change(Buyer, :count).by(1)
      end

      it 'redirects to buyer#show' do
        post :create, params: { buyer: attributes_for(:buyer) }
        expect(response).to redirect_to(buyer_path(assigns[:buyer]))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new buyer in the database' do
        expect{
          post :create, params: { buyer: attributes_for(:invalid_buyer) }
        }.not_to change(Buyer, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { buyer: attributes_for(:invalid_buyer) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @buyer = create(:buyer)
    end
    
    context 'with valid attributes' do
      it 'locates the requested @buyer' do
        patch :update, params: { id: @buyer, buyer: attributes_for(:buyer) }
        expect(assigns(:buyer)).to eq(@buyer)
      end

      it "changes @buyer's attributes" do
        patch :update, params: { id: @buyer, buyer: attributes_for(:buyer, name: 'Hermione G') }
        @buyer.reload
        expect(@buyer.name).to eq('Hermione G')
      end

      it 'redirects to buyer#show' do
        patch :update, params: { id: @buyer, buyer:attributes_for(:buyer) }
        expect(response).to redirect_to(@buyer)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the buyer in the database' do
        patch :update, params: { id: @buyer, buyer: attributes_for(:buyer, name: 'Hermione', phone: nil) }
        @buyer.reload
        expect(@buyer.name).not_to eq('Hermione')
      end

      it 're-renders the :edit template' do
        patch :update, params: { id: @buyer, buyer: attributes_for(:invalid_buyer) }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @buyer = create(:buyer)
    end

    it 'deletes the buyer from the database' do
      expect{
          delete :destroy, params: { id: @buyer }
        }.to change(Buyer, :count).by(-1)
    end

    it 'redirects to buyer#index' do
      delete :destroy, params: { id: @buyer }
      expect(response).to redirect_to(buyers_path)
    end
  end
end