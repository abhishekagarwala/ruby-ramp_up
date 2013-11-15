class TweetsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @tweet = Tweet.new(params[:tweet].permit(:body))
    @tweet.user_id = current_user.id

    @tweet.save
    redirect_to tweets_path
  end

  def index
    users_for_tweets = Follow.where(:follower_id => current_user.id).pluck(:following_id)
    users_for_tweets.append(current_user.id)

    @tweets = Tweet.where(user_id: users_for_tweets).order('created_at asc')
  end
end
