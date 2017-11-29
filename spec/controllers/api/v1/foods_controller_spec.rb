require 'rails_helper'

describe Api::V1::FoodsController do
  before :each do
    user = create(:user)
    session[:user_id] = user.id
  end

  describe 'GET #index' do
    context 'with params[:letter]' do
      it 'populates an array of foods starting with the letter' do
        nasi_uduk = create(:food, name: 'Nasi Uduk')
        kerak_telor = create(:food, name: 'Kerak Telor')
        get :index, params: { letter: 'N' }, format: 'json'
        expect(assigns(:foods)).to match_array([nasi_uduk])
      end
    end

    context 'without param[:letter]' do
      it 'populates an array of all foods' do
        nasi_uduk = create(:food, name: 'Nasi Uduk')
        kerak_telor = create(:food, name: 'Kerak Telor')
        get :index, format: 'json'
        expect(assigns(:foods)).to match_array([nasi_uduk, kerak_telor])
      end
    end

    context 'with searching parameters' do
      before :each do
        @food1 = create(:food, name: 'Beef Burger', description: 'burger daging sapi', price: 25000)
        @food2 = create(:food, name: 'Chicken Burger', description: 'burger ayam', price: 20000)
        @food3 = create(:food, name: 'Spaghetti', description: 'Classic Italian pasta', price: 40000)
      end

      it 'populates an array of foods containing name param' do
        get :index, params: { food: {name: 'burger'} }, format: 'json'
        expect(assigns(:foods)).to match_array([@food1, @food2])
      end

      it 'populates an array of foods containing description param' do
        get :index, params: { food: {description: 'ayam'} }, format: 'json'
        expect(assigns(:foods)).to match_array([@food2])
      end

      it 'populates an array of foods with price >= params' do
        get :index, params: { food: {min_price: 25000} }, format: 'json'
        expect(assigns(:foods)).to match_array([@food1, @food3])
      end

      it 'populates an array of foods with price <= params' do
        get :index, params: { food: {max_price: 25000} }, format: 'json'
        expect(assigns(:foods)).to match_array([@food1, @food2])
      end

      it 'populates an array of foods with combination of search params' do
        get :index, params: { food: {name: 'burger', description: 'ayam', max_price: 25000} }, format: 'json'
        expect(assigns(:foods)).to match_array([@food2])
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested food to @food' do
      food = create(:food)
      get :show, params: { id: food }, format: 'json'
      expect(assigns(:food)).to eq(food)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before :each do
        @rest = create(:restaurant)
      end
      it 'saves the new food in the database' do
        expect{
          post :create, params: { food: attributes_for(:food, restaurant_id: @rest.id) }, format: 'json'
        }.to change(Food, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new food in the database' do
        expect{
          post :create, params: { food: attributes_for(:invalid_food) }, format: 'json'
        }.not_to change(Food, :count)
      end
    end

    context 'adding tags to food' do
      it 'saves tags to food in the database' do
        tag1 = create(:tag)
        tag2 = create(:tag)
        post :create, params: { food: attributes_for(:food, tag_ids:[tag1, tag2]) }, format: 'json'
        expect(assigns(:food).tags).to include(tag1, tag2)
      end
    end
  end

end
