require 'rails_helper'

describe CategoriesController do
  describe 'GET #index' do
    it 'populates an array of all categories' do
      category1 = create(:category)
      category2 = create(:category)
      get :index
      expect(assigns(:categories)).to match_array([category1, category2])
    end

    it 'renders the :index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested category to @category' do
      category = create(:category)
      get :show, params: { id: category }
      expect(assigns(:category)).to eq(category)
    end

    it 'shows all foods in that category' do
      category = create(:category)
      food1 = create(:food, category: category)
      food2 = create(:food, category: category)
      get :show, params: { id: category }
      expect(assigns(:foods)).to match_array([food1, food2])
    end

    it 'renders the :show template' do
      category = create(:category)
      get :show, params: { id: category }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new category to @category' do
      get :new
      expect(assigns(:category)).to be_a_new(Category)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested category to @category' do
      category = create(:category)
      get :edit, params: { id: category }
      expect(assigns(:category)).to eq(category)
    end

    it 'renders the :edit template' do
      category = create(:category)
      get :edit, params: { id: category}
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new category in the database' do
        expect{
          post :create, params: { category: attributes_for(:category) }
        }.to change(Category, :count).by(1)
      end

      it 'redirects to category#show' do
        post :create, params: { category: attributes_for(:category) }
        expect(response).to redirect_to(category_path(assigns[:category]))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new category in the database' do
        expect{
          post :create, params: { category: attributes_for(:category, name: nil) }
        }.not_to change(Category, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { category: attributes_for(:category, name: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @category = create(:category)
    end

    context 'with valid attributes' do
      it 'locates the requested category' do
        patch :update, params: { id: @category, category: attributes_for(:category) }
        expect(assigns(:category)).to eq(@category)
      end

      it "changes @category's attributes" do
        patch :update, params: { id: @category, category: attributes_for(:category, name: 'lokal') }
        @category.reload
        expect(@category.name).to eq('lokal')
      end

      it 'redirects to category#show' do
        patch :update, params: { id: @category, category:attributes_for(:category) }
        expect(response).to redirect_to(@category)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the category in the database' do
        patch :update, params:{ id: @category, category: attributes_for(:category, name: nil) }
        @category.reload
        expect(@category.name).not_to eq(nil)
      end

      it 're-renders the :edit template' do
        patch :update, params:{ id: @category, category: attributes_for(:category, name: nil) }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @category = create(:category)
    end

    it 'does not delete the category from database if some food is using it' do
      food = create(:food, category: @category)
      expect{
        delete :destroy, params: { id: @category }
      }.not_to change(Category, :count)
    end

    it 'deletes the category from the database if no food is using it' do
      expect{
        delete :destroy, params: { id: @category }
      }.to change(Category, :count).by(-1)
    end

    it 'redirects to category#index' do
      delete :destroy, params: { id: @category }
      expect(response).to redirect_to(categories_path)
    end
  end
end
