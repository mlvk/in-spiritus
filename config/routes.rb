require 'sidekiq/web'

Rails.application.routes.draw do

  jsonapi_resources :addresses
  jsonapi_resources :companies
  jsonapi_resources :credit_notes
  jsonapi_resources :credit_note_items
  jsonapi_resources :fulfillments
  jsonapi_resources :items
  jsonapi_resources :item_desires
  jsonapi_resources :item_prices
  jsonapi_resources :item_credit_rates
  jsonapi_resources :locations
  jsonapi_resources :notifications
  jsonapi_resources :notification_rules
  jsonapi_resources :price_tiers
  jsonapi_resources :stocks
  jsonapi_resources :stock_levels
  jsonapi_resources :route_plans
  jsonapi_resources :route_plan_blueprints
  jsonapi_resources :route_plan_blueprint_slots
  jsonapi_resources :route_visits
  jsonapi_resources :pods
  jsonapi_resources :orders
  jsonapi_resources :order_items
  jsonapi_resources :users
  jsonapi_resources :visit_days
  jsonapi_resources :visit_windows
  jsonapi_resources :visit_window_days

  devise_for :users, controllers: { sessions: 'sessions' }

  # Custom action endpoints
  post 'orders/stub_orders'
  post 'orders/duplicate_sales_orders'
  post 'orders/generate_pdf'

  post 'route_visits/submit'

  post 'documents/generate_packing_documents'

  post 'custom/unique_check'

  post 'reports/customer_financials_by_range'
  post 'reports/product_financials_by_range'

  get 'testing/pdf'

  get '/routing/optimize_route/:id', to: 'routing#optimize_route'

  mount Sidekiq::Web => '/sidekiq'
end
