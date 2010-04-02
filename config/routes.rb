ActionController::Routing::Routes.draw do |map|
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.forgot_password  'forgot-password', :controller => 'password_resets', :action => 'new'
  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'

  map.resource :account, :controller => "users"
  map.resources :password_resets
  map.resources :users
  map.resources :user_sessions

  map.resources :projects
  map.resources :tasks
  map.root :projects
end
