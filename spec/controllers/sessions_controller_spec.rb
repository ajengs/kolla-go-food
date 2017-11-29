require 'rails_helper'

describe SessionsController do
  describe 'GET #new' do
    it 'renders the :new template' do
      get :new
      expect(:response).to render_template :new
    end
  end

  describe 'POST #create' do
    before :each do
      @role = create(:role, name: 'administrator')
      @role2 = create(:role, name: 'customer')
      @user = create(:user, username: 'user1', password: 'longpassword', password_confirmation: 'longpassword')
      @user.role_ids = @role.id
      @user.save!
      @user.reload
    end

    context 'with valid username and password' do
      it 'assigns user_id to session variable' do
        post :create, params: { username: 'user1', password: 'longpassword' }
        expect(session[:user_id]).to eq(@user.id)
      end

      it 'redirects to admin index page if user is administrator' do
        post :create, params: { username: 'user1', password: 'longpassword' }
        expect(response).to redirect_to(admin_url)
      end

      it 'redirects to store index page if user is customer' do
        @user.role_ids = @role2.id
        @user.save!
        @user.reload
        post :create, params: { username: 'user1', password: 'longpassword' }
        expect(response).to redirect_to(store_index_url)
      end
    end

    context 'with invalid username and password' do
      it 'redirects to login page' do
        post :create, params: { username: 'user1', password: 'wrongpassword' }
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @user = create(:user, username: 'user')
    end

    it 'removes user_id from session variable' do
      delete :destroy, params: { id: @user }
      expect(session[:user_id]).to eq(nil)
    end

    it 'redirects to login page' do
      delete :destroy, params: { id: @user }
      expect(response).to redirect_to(store_index_url)
    end
  end
end
