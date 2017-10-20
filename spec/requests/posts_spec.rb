require 'rails_helper'

describe 'Posts' do
  let(:user) { create(:user) }
  let(:valid_attr) { attributes_for(:post, author_id: user.id) }

  context 'factory is valid' do
    it 'build' do
      post = build(:post)
      expect(post).to be_valid
    end

    it 'create' do
      post = create(:post)
      expect(post.errors.messages).to be_empty
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { post '/api/v1/posts', params: valid_attr }

      it 'returns http created' do
        expect(response).to have_http_status(:created)
      end

      %w[id title body published_at author_nickname].each do |attr|
        it "is have #{attr} attribute" do
          expect(JSON.parse(response.body)[attr]).not_to be_nil
        end
      end
    end

    context 'with invalid attributes' do
      before { post '/api/v1/posts', params: {} }

      it 'returns http unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'is have errors messages' do
        expect(response.body).to match /can't be blank/
      end
    end
  end

  describe 'GET #show' do
    let(:post) { create(:post) }

    it 'is return post by id' do
      get "/api/v1/posts/#{post.id}"
      expect(JSON.parse(response.body)['id']).to eq post.id
    end

    it 'is return error if wrong id' do
      wrong_id = post.id - 1
      get "/api/v1/posts/#{wrong_id}"
      expect(JSON.parse(response.body)).to eq "error" => "Couldn't find Post with 'id'=#{wrong_id}"
    end
  end

  describe 'GET #index' do

  end
end
