require 'rails_helper'

describe ReviewsController do
  describe 'GET #index' do
    it 'populates an array of all reviews' do
      review1 = create(:review)
      review2 = create(:review)
      get :index
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it 'renders the :index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  # describe 'GET #show' do
  #   it 'assigns the requested review to @review' do
  #     review = create(:review)
  #     get :show, params: { id: review }
  #     expect(assigns(:review)).to eq(review)
  #   end

  #   it 'renders the :show template' do
  #     review = create(:review)
  #     get :show, params: { id: review }
  #     expect(response).to render_template(:show)
  #   end
  # end

  describe 'GET #new' do
    before :each do
      @food = create(:food)
    end
    it 'assigns a new review to @review' do
      get :new, params: { food_id: @food }
      expect(assigns(:review)).to be_a_new(Review)
    end

    it 'renders the :new template' do
      get :new, params: { food_id: @food }
      expect(response).to render_template(:new)
    end
  end

  # describe 'GET #edit' do
  #   it 'assigns the requested review to @review' do
  #     review = create(:review)
  #     get :edit, params: { id: review }
  #     expect(assigns(:review)).to eq(review)
  #   end

  #   it 'renders the :edit template' do
  #     review = create(:review)
  #     get :edit, params: { id: review }
  #     expect(response).to render_template(:edit)
  #   end
  # end

  describe 'POST #create' do
    before :each do
      @rest = create(:restaurant)
    end

    context 'with valid attributes' do
      it 'saves the new review in the database' do
        expect{
          post :create, params: { review: attributes_for(:review), restaurant_id: @rest }
        }.to change(Review, :count).by(1)
      end

      it 'redirects to reviewable#show' do
        post :create, params: { review: attributes_for(:review), restaurant_id: @rest }
        expect(response).to redirect_to(@rest)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new review in the database' do
        expect{
          post :create, params: { review: attributes_for(:invalid_review), restaurant_id: @rest }
        }.not_to change(Review, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { review: attributes_for(:invalid_review), restaurant_id: @rest }
        expect(response).to render_template(:new)
      end
    end
  end

  # describe 'PATCH #update' do
  #   before :each do
  #     @review = create(:review)
  #   end
    
  #   context 'with valid attributes' do
  #     it 'locates the requested @review' do
  #       patch :update, params: { id: @review, review: attributes_for(:review) }
  #       expect(assigns(:review)).to eq(@review)
  #     end

  #     it "changes @review's attributes (amount)" do
  #       patch :update, params: { id: @review, review: attributes_for(:review, name: 'local') }
  #       @review.reload
  #       expect(@review.name).to eq('local')
  #     end

  #     it 'redirects to review#show' do
  #       patch :update, params: { id: @review, review:attributes_for(:review) }
  #       expect(response).to redirect_to(@review)
  #     end
  #   end

  #   context 'with invalid attributes' do
  #     it 'does not save the review in the database' do
  #       patch :update, params: { id: @review, review: attributes_for(:review, name: nil) }
  #       @review.reload
  #       expect(@review.name).not_to eq(nil)
  #     end

  #     it 're-renders the :edit template' do
  #       patch :update, params: { id: @review, review: attributes_for(:invalid_review) }
  #       expect(response).to render_template(:edit)
  #     end
  #   end
  # end

  describe 'DELETE #destroy' do
    before :each do
      @review = create(:review)
    end

    it 'deletes the review from the database' do
      expect{
          delete :destroy, params: { id: @review }
        }.to change(Review, :count).by(-1)
    end

    it 'redirects to review#index' do
      delete :destroy, params: { id: @review }
      expect(response).to redirect_to(reviews_url)
    end
  end
end
