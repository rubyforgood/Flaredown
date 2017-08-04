require 'rails_helper'

RSpec.describe Api::V1::TagsController do
  let!(:user) { create(:user) }
  let!(:tag) { create(:tag) }

  let(:user_abilities) { Ability.new(user) }
  let(:accessible_tags) { Tag.accessible_by(user_abilities) }

  before { sign_in user }

  describe 'index' do
    it 'returns all accessible tags' do
      get :index
      returned_tag_ids = response_body[:tags].map { |c| c[:id] }
      accessible_tag_ids = accessible_tags.map(&:id)
      expect(returned_tag_ids.to_set).to eq accessible_tag_ids.to_set
    end
    context 'with ids param' do
      let(:tag_ids) { create_list(:tag, 2).map(&:id) }
      it 'returns requested tags only' do
        get :index, ids: tag_ids
        returned_tag_ids = response_body[:tags].map { |c| c[:id] }
        expect(returned_tag_ids.to_set).to eq tag_ids.to_set
      end
    end
  end

  describe 'show' do
    it 'returns the requested tag' do
      get :show, id: tag.id
      expect(response_body[:tag][:id]).to eq tag.id
    end
  end

  describe 'create' do
    let(:tag_attributes) { { name: 'had sex' } }
    it 'creates the tag' do
      post :create, tag: tag_attributes
      created_tag = response_body[:tag]
      expect(created_tag[:name]).to eq tag_attributes[:name]
      expect(Tag.find(created_tag[:id]).global).to be false
    end
  end
end
