# routes.rb
# need to clean this up desperately

Fivethings::Application.routes.draw do
  root :to => 'intro#index'

  resources :users
  resources :tasks
  resources :password_resets
  resources :tasklists
  
  match "logout" => "user_sessions#destroy", :as => :logout  
  match "login" => "user_sessions#new", :as => :login
  match "register/:activation_code" => "activations#new", :as => :register
  match "activate/:id" => "activations#create", :as => :activate

  match "home" => "tasks#index", :as => :home
  match "help" => "intro#help", :as => :help
    
  match "find_today" => "tasks#find_today", :as => :find_today
  match 'set_help' => 'tasks#set_help', :as => :set_help

  # share lists
  match 'share/:id' => 'tasklists#show', :as => :share
  match 'set/:id' => 'users#set_list', :as => :set

  # kinda messy, but will have to do for now
  match 'tasklists/:id' => 'tasklists#update', :as => :update
  match 'tasklists/:id/destroy' => 'tasklists#destroy', :as => :destroylist
  match 'tasks/:id/remove' => 'tasks#remove', :as => :removetask
  
  # refactor/remove
  # map.with_options :controller => 'contact' do |contact|
  #   contact.contact '/contact',
  #     :action => 'index',
  #     :conditions => { :method => :get }

  #   contact.contact '/contact',
  #     :action => 'create',
  #     :conditions => { :method => :post }
  # end
  
  resource :user_session
  
  match 'resend' => 'users#resend'
  match 'rs' => 'users#rs'

  match 'list' => 'tasks#list'
  match 'sort' => 'tasks#sort'
  match 'checkcompleted' => 'tasks#checkcompleted'
  match 'update' => 'tasks#update'
  match 'destroytask' => 'tasks#destroytask'
  match 'maintenance' => 'tasks#maintenance'

  match 'about' => 'intro#about'
  match 'privacy' => 'intro#privacy'
  match 'terms' => 'intro#terms'
  match 'statistics' => 'intro#stats'

  match 'ical' => 'tasks#export_ics'
  match 'csv' => 'tasks#export_csv'
  match 'delete' => 'users#delete'
  match 'preferences' => 'users#preferences'
  
  match '/404', :to => 'intro#not_found'
end