ActionController::Routing::Routes.draw do |map|
  map.signup 'signup', :controller => 'users', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.forgot_password  'forgot-password', :controller => 'password_resets', :action => 'new'

  map.resource :account, :controller => "users"
  map.resources :password_resets
  map.resources :users
  map.resources :user_sessions

  map.resources :projects
  map.resources :tasks
  map.root :projects
end
