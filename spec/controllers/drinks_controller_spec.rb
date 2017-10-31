require 'rails_helper'

describe DrinksController do
  describe 'GET #index' do
    before :each do
      @drink1 = create(:drink, name: 'milk')
      @drink2 = create(:drink, name: 'coffee')
    end

    context 'with params[:letter]' do
      it 'populates an array of drinks starting with the letter' do
        get :index, params: { letter: 'm' }
        expect(assigns(:drinks)).to match_array([@drink1])
      end

      it 'renders the :index template' do
        get :index, params: { letter: 'm' }
        expect(response).to render_template(:index)
      end
    end

    context 'without params[:letter]' do
      it 'populates an array of all drinks' do
        get :index
        expect(assigns(:drinks)).to match_array([@drink1, @drink2])
      end

      it 'renders the :index template' do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested drink to @drink' do
      drink = create(:drink)
      get :show, params: { id: drink }
      expect(assigns(:drink)).to eq(drink)
    end

    it 'renders the :show template' do
      drink = create(:drink)
      get :show, params: { id: drink }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns new drink to @drink' do
      get :new
      expect(assigns(:drink)).to be_a_new(Drink)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested drink to @drink' do
      drink = create(:drink)
      get :edit, params: { id: drink }
      expect(assigns(:drink)).to eq(drink)
    end

    it 'renders the :edit template' do
      drink = create(:drink)
      get :edit, params: { id: drink }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new drink in the database' do
        expect{
          post :create, params: { drink: attributes_for(:drink) }
        }.to change(Drink, :count).by(1)
      end

      it 'redirects to drink#show' do
        post :create, params: { drink: attributes_for(:drink) }
        expect(response).to redirect_to(drink_path(assigns[:drink]))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new drink in the database' do
        expect{
          post :create, params: { drink: attributes_for(:invalid_drink) }
        }.not_to change { Drink.count }
      end

      it 're-renders the :new template' do
        post :create, params: { drink: attributes_for(:invalid_drink) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @drink = create(:drink)
    end

    context 'with valid attributes' do
      it 'locates the requested @drink' do
        patch :update, params: { id: @drink, drink: attributes_for(:drink) }
        expect(assigns(:drink)).to eq(@drink)
      end

      it "changes @drink's attributes" do
        patch :update, params: { id: @drink, drink: attributes_for(:drink, name: 'water') }
        @drink.reload
        expect(@drink.name).to eq('water')
      end

      it "changes @drink's category" do
        category2 = create(:category)
        patch :update, params: { id: @drink, drink: attributes_for(:drink, category_id: category2.id) }
        @drink.reload
        expect(@drink.category_id).to eq(category2.id)
      end

      it 'redirects to drink#show' do
        patch :update, params: { id: @drink, drink: attributes_for(:drink) }
        expect(response).to redirect_to(@drink)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the drink in the database' do
        patch :update, params: { id: @drink, drink: attributes_for(:invalid_drink) }
        @drink.reload
        expect(@drink.name).not_to eq(nil)
      end

      it 're-renders the :edit template' do
        patch :update, params: { id: @drink, drink: attributes_for(:invalid_drink) }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @drink = create(:drink)
    end

    it 'deletes the drink from the database' do
      expect {
        delete :destroy, params: { id: @drink }
        }.to change(Drink, :count).by(-1)
    end

    it 'redirects to drink#index' do
      delete :destroy, params: { id: @drink }
      expect(response).to redirect_to(drinks_url)
    end
  end
end
