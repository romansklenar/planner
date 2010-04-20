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
  map.resources :tasks, :only => [:show], :collection => { :recent => :get }

  map.resources :projects, :member => { :archive => :get, :restore => :get, :accept => :post } do |projects|
    # projects.resource  :user
    projects.resources :tags
    projects.resources :tasks,
      :has_many => :tags,
      :member => { :toggle => :post },
      :collection => { :sort       => :post,
                       :toggle_all => :post,
                       :recent     => :get }
  end

  map.root :projects
end
