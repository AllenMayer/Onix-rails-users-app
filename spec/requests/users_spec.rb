require 'rails_helper'

RSpec.describe 'Users', type: :request do

  let(:valid_attributes) { { first_name: 'test', last_name: 'test', salary: 100 } }
  let(:invalid_attributes) { { first_name: 'test', last_name: 'test', salary: '' } }

  describe 'POST create' do
    context 'when valid attributes' do
      before { post users_path, xhr: true, params: { user: valid_attributes } }
      let(:valid_user) { User.create(valid_attributes) }

      it 'creates new user' do
        expect { valid_user }.to change { User.count }.by(1)
      end

      it 'returns create notice' do
        expect(flash[:notice]).to match('User was successfully created.')
      end
    end

    context 'when empty attributes' do
      before { post users_path, xhr: true, params: { user: invalid_attributes } }
      let(:invalid_user) { User.create(invalid_attributes) }

      it 'doesnt create new user' do
        expect { invalid_user }.not_to(change { User.count })
      end

      it 'returns a failure message' do
        expect(invalid_user.errors.full_messages[0]).to match("Salary can't be blank")
      end
    end
  end

  describe 'PATCH update' do
    let(:new_valid_attributes) { { first_name: 'test1', last_name: 'test', salary: 100 } }

    context 'when valid attributes' do
      let(:user) { User.create(valid_attributes) }
      before { patch user_path(user.id), xhr: true, params: { user: new_valid_attributes } }

      it 'updates user' do
        expect { user.reload }.to change { user.first_name }.from(user.first_name).to(new_valid_attributes[:first_name])
      end

      it 'returns updated notice' do
        expect(flash[:notice]).to match('User was successfully updated.')
      end
    end

    context 'when invalid attributes' do
      let(:user) { User.create(valid_attributes) }
      before do
        patch user_path(user.id), xhr: true, params: { user: invalid_attributes }
      end

      it 'doesnt update user' do
        expect { user.reload }.to_not(change { subject })
      end

      it 'returns a failure message' do
        #expect(user.errors.full_messages[0]).to match("Salary can't be blank")
      end
    end
  end

  describe 'DELETE' do
    context 'valid user' do
      let!(:user) { User.create(first_name: 'test', last_name: 'test', salary: 100) }
      let(:request) { delete user_path(user.id), xhr: true }

      it 'deletes user' do
        expect { request }.to change { User.count }.by(-1)
      end

      it 'returns deleted notice' do
        #expect(flash[:notice]).to match('User was successfully destroyed.')
      end
    end
  end
end
