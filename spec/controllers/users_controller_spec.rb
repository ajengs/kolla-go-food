require 'rails_helper'

describe UsersController do
  before :each do
    @user = create(:user)
    session[:user_id] = @user.id
  end
  
  describe 'GET #index' do
    it 'populates an array of all users' do
      user1 = create(:user, username: "user1")
      user2 = create(:user, username: "user2")
      get :index
      expect(assigns(:users)).to match_array([@user, user1, user2])
    end

    it 'renders the :index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user to @user' do
      user = create(:user)
      get :show, params: { id: user }
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the :show template' do
      user = create(:user)
      get :show, params: { id: user }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new User to @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested user to @user' do
      user = create(:user)
      get :edit, params: { id: user }
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the :edit template' do
      user = create(:user)
      get :edit, params: { id: user }
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new user in the database' do
        expect {
          post :create, params: { user: attributes_for(:user) }
        }.to change(User, :count).by(1)
      end

      it 'redirects to user#index' do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to redirect_to(users_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new user in the database' do
        expect{
          post :create, params: { user: attributes_for(:invalid_user) }
        }.not_to change(User, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { user: attributes_for(:invalid_user) }
        expect(response).to render_template(:new)
      end
    end

    context 'with roles assigned' do
      it 'saves role_id(s) in the database for that user' do
        role = create(:role)
        post :create, params: { user: attributes_for(:user, role_ids: [role]) }
        expect(assigns(:user).roles).to include(role)
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @user = create(:user, password: 'oldpassword', password_confirmation: 'oldpassword')
    end

    context 'with valid attributes' do
      it 'locates the requested @user' do
        patch :update, params: { id: @user, user: attributes_for(:user) }
        expect(assigns(:user)).to eq(@user)
      end

      it "saves the new password" do
        patch :update, params: { id: @user, user: attributes_for(:user, password: 'newlongpassword', password_confirmation: 'newlongpassword') }
        @user.reload
        expect(@user.authenticate('newlongpassword')).to eq(@user)
      end

      it 'redirect to the user' do
        patch :update, params: { id: @user, user: attributes_for(:user) }
        expect(response).to redirect_to(users_path)
      end

      it 'disables login with old password' do
        patch :update, params: { id: @user, user: attributes_for(:user, password: 'newlongpassword', password_confirmation: 'newlongpassword') }
        @user.reload
        expect(@user.authenticate('oldpassword')).to eq(false)
      end
    end

    context 'with invalid attributes' do
      it "does not change user's attributes" do
        patch :update, params: { id: @user, user: attributes_for(:user, password: nil, password_confirmation: nil) }
        @user.reload
        expect(@user.authenticate(nil)).to eq(false)
      end

      it 're-renders the :edit template' do
        patch :update, params: { id: @user, user: attributes_for(:invalid_user) }
        expect(response).to render_template(:edit)
      end
    end

    context 'with roles assigned' do
      it 'saves role_id(s) in the database for that user' do
        role = create(:role)
        role2 = create(:role)
        user = create(:user)
        user.roles << role

        post :update, params: { id: user, user: attributes_for(:user, role_ids: [role2]) }
        expect(assigns(:user).roles).to include(role2)
      end
    end

    it 'does not update gopay attribute when updating user' do
      patch :update, params: { id: @user, user: attributes_for(:user, gopay: 100000) }
      expect(assigns(:user).gopay).not_to eq(100000)
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @user = create(:user)
    end
    
    it 'deletes user from the database' do
      expect{
        delete :destroy, params: { id: @user }
      }.to change(User, :count).by(-1)
    end

    it 'redirects to user#index' do
      delete :destroy, params: { id: @user }
      expect(response).to redirect_to(users_path)
    end
  end

  describe 'GET #topup' do
    before :each do
      @user = create(:user)
    end

    it 'assigns the requested user to @user' do
      get :topup, params: { id: @user }
      expect(assigns(:user)).to eq(@user)
    end

    it 'renders the :topup template' do
      get :topup, params: { id: @user }
      expect(response).to render_template(:topup)
    end
  end

  describe 'PATCH #save_topup' do
    before :each do
      @user = create(:user, gopay: 100000)
    end

    context 'with valid gopay amount' do
      it "adds topup amount to user's gopay in the database" do
        patch :save_topup, params: { id: @user, user: attributes_for(:user, gopay: 150000) }
        @user.reload
        expect(@user.gopay).to eq(250000)
      end

      it 'redirect to the user' do
        patch :save_topup, params: { id: @user, user: attributes_for(:user, gopay: 150000) }
        expect(response).to redirect_to(users_path)
      end
    end

    context 'with invalid gopay amount' do
      it "does not change topup amount to user's gopay in the database" do
        patch :save_topup, params: { id: @user, user: attributes_for(:user, gopay: -50000) }
        @user.reload
        expect(@user.gopay).not_to eq(50000)
      end

      it 're-renders topup template' do
        patch :save_topup, params: { id: @user, user: attributes_for(:user, gopay: -50000) }
        expect(response).to renders(:topup)
      end
    end
  end
end
