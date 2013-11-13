class HomeController < ApplicationController
  before_filter :authenticate_user!
  def follow_user
    following_user = User.find_by username: params[:follow][:username]


    if following_user
      following_msg = 'Already Following the User'
      Follow.find_or_create_by(follower_id: current_user.id, following_id: following_user.id) do |f|
        following_msg = 'Successfully Following the User'
      end
      flash[:notice] = following_msg
      redirect_to following_path
    else
      flash[:notice] = 'User Not Found'
      redirect_to following_path
    end
  end

  def following
    @following = Follow.where(:follower => current_user)
  end

  def un_follow
    Follow.where(:follower => current_user, following_id: params[:id]).destroy_all

    redirect_to following_path
  end

  def follower
    @followers = Follow.where(:following => current_user)
  end
end
