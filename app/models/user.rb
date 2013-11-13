class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:username]

  has_many :tweets

  has_many :followers, :class_name => "Follow", :foreign_key => :follower_id
  has_many :followings, :class_name => "Follow", :foreign_key => :following_id

  validates_presence_of :username
  validates_uniqueness_of :username
end
