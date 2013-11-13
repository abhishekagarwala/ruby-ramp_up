Twitter::Application.routes.draw do
  devise_for :users
  resources :tweets , except: [:new, :show]

  get 'following', to: 'home#following'
  get 'follower', to: 'home#follower'
  post 'follow', to: 'home#follow_user'
  delete 'un_follow', to: 'home#un_follow'

  root :to =>'home#index'
end
