Leasingx::Engine.routes.draw do

  mount Authentify::Engine => "/authentify"  #, :as => "authentify_engine"
  mount Customerx::Engine => "/customerx"  #, :as => "authentify_engine"

  match '/view_handler', :to => 'application#view_handler'

  resources :customer
  resources :lease_logs
  resources :lease_bookings
  resources :lease_bookings do
    collection do
      get 'search'
      put 'search_results'
      get 'stats'
      put 'stats_results'
    end
    resources :lease_logs
    match '/lease_bookings/setst', :to => 'lease_bookings#setst'
  end

  resources :lease_items do
    collection do
      get 'search'
      put 'search_results'
    end
  end

end
