require 'spec_helper'

describe HomeController, :type => :controller do
  describe 'Home Controller' do
    before :each do
      @user = User.create!(:username => 'test1', :email => 'test@test.com', :password => 'password')
      sign_in :user, @user
    end

    # Following Action
    describe "following" do
      it "renders the following template" do
        get :following
        expect(response).to render_template("following")
      end

      it "list of following users" do
        get :following
        # currently following no one
        assigns(:following).count.should eq(0)
        # add a new following
        new_user = User.create!(:username => 'test2', :email => 'test2@test.com', :password => 'password')
        Follow.create(:follower => @user, :following => new_user)
        get :following
        # currently following no one
        assigns(:following).count.should eq(1)
      end
    end

    # Follower Action
    describe "follower" do
      it "renders the follower template" do
        get :follower
        expect(response).to render_template("follower")
      end

      it "list of followers" do
        get :follower
        # currently following no one
        assigns(:followers).count.should eq(0)
        # add a new following
        new_user = User.create!(:username => 'test2', :email => 'test2@test.com', :password => 'password')
        Follow.create(:following => @user, :follower => new_user)
        get :follower
        # currently following no one
        assigns(:followers).count.should eq(1)
      end
    end

    # follow_user Action
    describe "follow user" do
      it "test redirect" do
        # User does not exist
        post :follow_user, follow: {username: 'test2'}
        # test redirect to following_path page
        response.should redirect_to following_path
      end

      it "test user not found" do
        # User does not exist
        post :follow_user, follow: {username: 'test2'}
        flash[:notice].should eq("User Not Found")
      end

      it "test user successfully added" do
        # User does not exist
        new_user = User.create!(:username => 'test2', :email => 'test2@test.com', :password => 'password')
        post :follow_user, follow: {username: 'test2'}

        flash[:notice].should eq("Successfully Following the User")
        Follow.where(:follower => @user, :following => new_user).exists?.should be_true
      end

      it "test already following" do
        # User does not exist
        new_user = User.create!(:username => 'test2', :email => 'test2@test.com', :password => 'password')
        Follow.create(:follower => @user, :following => new_user)
        post :follow_user, follow: {username: 'test2'}

        flash[:notice].should eq("Already Following the User")
      end
    end

    # un_follow Action
    describe "un_follow user" do
      it "un follow a user" do
        new_user = User.create!(:username => 'test2', :email => 'test2@test.com', :password => 'password')
        Follow.create(:follower => @user, :following => new_user)
        # test following
        Follow.where(:follower => @user, :following => new_user).exists?.should be_true

        post :un_follow, id: new_user.id
        #test following
        Follow.where(:follower => @user, :following => new_user).exists?.should be_false
      end
    end
  end
end