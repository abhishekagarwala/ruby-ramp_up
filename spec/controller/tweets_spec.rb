require 'spec_helper'

describe TweetsController, :type => :controller do
  describe 'Test tweets_controller' do
    before :each do
      @user = User.create!(:username => 'test1', :email => 'test@test.com', :password => 'password')
      sign_in :user, @user
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "get the correct tweets list" do
      new_user = User.create!(:username => 'test2', :email => 'test2@test.com', :password => 'password')
      # create some sample tweets
      Tweet.create(:user => @user, :body => 'user 1 tweet 1')
      Tweet.create(:user => @user, :body => 'user 1 tweet 2')
      Tweet.create(:user => new_user, :body => 'user 2 tweet 1')
      Tweet.create(:user => new_user, :body => 'user 2 tweet 2')
      # When no followers tweets count is 2
      get :index
      assigns(:tweets).count.should eq(2)
      Follow.create(:follower => @user, :following => new_user)
      # When following new_user the count is 4(self + following)
      get :index
      assigns(:tweets).count.should eq(4)
    end

    it "create a new tweet" do
      post :create, tweet: {body: 'test new tweet'}
      # test redirect to tweets page
      response.should redirect_to tweets_path
      # test if the new tweet exists
      Tweet.where(:user_id => @user.id, :body => 'test new tweet').exists?.should be_true
    end
  end
end