require 'spec_helper'

describe Tweet do

  it 'create a tweet' do
    user = User.create!(:username => 'test1', :email => 'test@test.com', :password => 'password')
    Tweet.create(:body => 'test tweet', :user => user).should be_valid

    expect(Tweet.find_by_user_id(user.id).body).to eq('test tweet')
  end
end