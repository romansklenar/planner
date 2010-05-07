ActionController::Routing::Routes.draw do |map|
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.forgot_password  'forgot-password', :controller => 'password_resets', :action => 'new'
  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'
  map.tags_filtering '/tags/:search', :controller => 'tags', :action => 'index', :seach => nil
  
  #  tasklists
  map.inbox       'inbox',      :controller => 'tasklists', :action => 'show', :list => 'inbox'
  map.next_steps  'next-steps', :controller => 'tasklists', :action => 'show', :list => 'next-steps'
  map.someday     'someday',    :controller => 'tasklists', :action => 'show', :list => 'someday'
  map.today       'today',      :controller => 'tasklists', :action => 'show', :list => 'today'
  map.tomorrow    'tomorrow',   :controller => 'tasklists', :action => 'show', :list => 'tomorrow'
  map.scheduled   'scheduled',  :controller => 'tasklists', :action => 'show', :list => 'scheduled'
  map.someday     'someday',    :controller => 'tasklists', :action => 'show', :list => 'someday'
  map.delegated   'delegated',  :controller => 'tasklists', :action => 'show', :list => 'delegated'
  map.completed   'completed',  :controller => 'tasklists', :action => 'show', :list => 'completed'
  map.trashed     'trashed',    :controller => 'tasklists', :action => 'show', :list => 'trashed'


  map.connect '/:list/tasks/tagged-by/:tag', :controller => 'tasklists', :action => 'show'
  map.connect '/delegated/:user', :controller => 'tasklists', :action => 'show', :list => 'delegated'
  

  map.resource  :account, :controller => "users"
  map.resources :password_resets
  map.resources :users, :member => { :delegate => :post}
  map.resources :user_sessions
  map.resources :tasks, :member => { :toggle => :post, :trash => :post, :complete => :post, :today => :post, :tomorrow => :post }, :collection => { :recent => :get, :sort => :post }, :has_many => :tags
  map.resources :tags, :except => [:index, :show]
  map.resources :bugs, :member => { :approve => :get, :assign => :get}, :collection => { :sort => :post }
  map.resources :worktypes
  map.resources :grants
  map.resources :timesheets

  map.resources :projects, :member => { :archivate => :get, :activate => :get, :accept => :post } do |projects|
    # projects.resource  :user
    projects.resources :tags
    projects.resources :tasks,
      :has_many => :tags,
      :member => { :toggle => :post, :trash => :post, :complete => :post },
      :collection => { :sort       => :post,
                       :toggle_all => :post,
                       :recent     => :get }
  end

  map.resources :tasklists, :member => { :archivate => :get, :activate => :get, :accept => :post } do |tasklists|
    # tasklists.resource  :user
    tasklists.resources :tags
    tasklists.resources :tasks,
      :has_many => :tags,
      :member => { :toggle => :post, :trash => :post, :complete => :post },
      :collection => { :sort       => :post,
                       :toggle_all => :post,
                       :recent     => :get }
  end


  map.connect ':controller/:action/:id.:format' 
  map.root :inbox
end
