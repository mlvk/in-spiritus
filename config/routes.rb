Rails.application.routes.draw do

  jsonapi_resources :clients
  jsonapi_resources :client_item_desires
  jsonapi_resources :client_visit_days
  jsonapi_resources :custom_orders
  jsonapi_resources :items
  jsonapi_resources :item_levels
  jsonapi_resources :item_prices
  jsonapi_resources :price_tiers
  jsonapi_resources :purchase_orders
  jsonapi_resources :route_plans
  jsonapi_resources :route_visits
  jsonapi_resources :route_visits
  jsonapi_resources :sales_orders
  jsonapi_resources :sales_order_items
  jsonapi_resources :users
  jsonapi_resources :visit_windows

  devise_for :users, controllers: { sessions: 'sessions' }

  # Custom action endpoints
  post 'sales_orders/stub_orders', to: 'sales_orders#stub_orders'
  post 'process_route_visits', to: 'route_visits#process_visits'

  # Testing routes
  post 'sales_orders/register_device_apn'
  get 'sales_orders/ping'
end
