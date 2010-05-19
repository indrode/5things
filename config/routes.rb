# routes.rb
# need to clean this up desperately

ActionController::Routing::Routes.draw do |map|

  #map.root :controller => "user_sessions", :action => "new"
  map.root :controller => "intro"

  map.resource :account, :controller => "users"
  map.resources :users
  map.resources :tasks
  map.resources :password_resets
  map.resources :tasklists
 
  # named routes
  # access like this: login_url or login_path
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'
  map.home '/home', :controller => 'tasks'
  map.help '/help', :controller => 'intro', :action => 'help'
  map.find_today '/find_today', :controller => 'tasks', :action => 'find_today'
  map.set_help '/set_help', :controller => 'tasks', :action => 'set_help'
  # share lists
  map.share '/share/:id', :controller => 'tasklists', :action => 'show'
  map.set '/set/:id', :controller => 'users', :action => 'set_list'
  # kinda messy, but will have to do for now
  map.update '/tasklists/:id', :controller => 'tasklists', :action => 'update'
  map.destroylist '/tasklists/:id/destroy', :controller => 'tasklists', :action => 'destroy'
  map.removetask '/tasks/:id/remove', :controller => 'tasks', :action => 'remove'
  
  map.with_options :controller => 'contact' do |contact|
    contact.contact '/contact',
      :action => 'index',
      :conditions => { :method => :get }

    contact.contact '/contact',
      :action => 'create',
      :conditions => { :method => :post }
  end
  
  map.resource :user_session
  #map.root :controller => "user_sessions", :action => "new"
  
  map.connect 'resend', :controller => "users", :action => "resend"
  map.connect 'rs', :controller => "users", :action => "rs"

  map.connect 'list', :controller => "tasks", :action => "list"
  map.connect 'sort', :controller => "tasks", :action => "sort"
  map.connect 'checkcompleted', :controller => "tasks", :action => "checkcompleted"
  map.connect 'update', :controller => "tasks", :action => "update"
  map.connect 'destroytask', :controller => "tasks", :action => "destroy"
  map.connect 'maintenance', :controller => "tasks", :action => "maintenance"

  #map.connect 'share', :controller => "tasklists", :action => "index"
  
  map.connect 'about', :controller => "intro", :action => "about"
  map.connect 'privacy', :controller => "intro", :action => "privacy"
  map.connect 'terms', :controller => "intro", :action => "terms"
  map.connect 'stats', :controller => "intro", :action => "stats"
  
  map.connect 'ical', :controller => "tasks", :action => "export_ics"
  map.connect 'csv', :controller => "tasks", :action => "export_csv"
  map.connect 'delete', :controller => "users", :action => "delete"
  map.connect 'preferences', :controller => "users", :action => "preferences"

  #map.connect ':controller/:action/:id.:format'
  
  map.error ':controllername',  :controller => 'intro', :action => 'notfound'
end