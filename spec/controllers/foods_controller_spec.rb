require 'rails_helper'

describe FoodsController do
  describe 'GET #index' do
    context 'with params[:letter]' do
      it 'populates an array of foods starting with the letter'
      it 'renders the :index template'
    end

    context 'without param[:letter]' do
      it 'populates an array of all foods'
      it 'renders the :index template'
    end
  end

  describe 'GET #show' do
    it 'assigns the requested food to @food'
    it 'renders the :show template'
  end

  describe 'GET #new' do
    it 'assigns a new food to @food'
    it 'renders the :new template'
  end

  describe 'GET #edit' do
    it 'assigns the requested food to @food'
    it 'renders the :edit template'
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new food in the database'
      it 'redirects to food#show'
    end

    context 'with invalid attributes' do
      it 'does not save the new food in the database'
      it 're-renders the :new template'
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'locates the requested @food'
      it "changes @food's attributes"
      # it 'saves the updated @food in the database' ???
      it 'redirects to food#show'
    end

    context 'with invalid attributes' do
      it 'does not save the food in the database'
      it 're-renders the :edit template'
    end
  end

  describe 'DELETE #destroy' do
    # it 'locates the requested @food' ????
    it 'deletes the food from the database'
    it 'redirects to food#index'
  end
end