# == Route Map
#
#                                Prefix Verb   URI Pattern                                                                              Controller#Action
#                                 login GET    /login(.:format)                                                                         sessions#new
#                                       POST   /login(.:format)                                                                         sessions#create
#                                logout GET    /logout(.:format)                                                                        sessions#destroy
#                         confirm_email GET    /users/:token/confirm_email(.:format)                                                    users#confirm_email
#                                 users POST   /users(.:format)                                                                         users#create
#                              new_user GET    /users/new(.:format)                                                                     users#new
#                                  user GET    /users/:id(.:format)                                                                     users#show
#                  password_reset_index POST   /password_reset(.:format)                                                                password_reset#create
#                    new_password_reset GET    /password_reset/new(.:format)                                                            password_reset#new
#                   edit_password_reset GET    /password_reset/:token/edit(.:format)                                                    password_reset#edit
#                        password_reset PATCH  /password_reset/:token(.:format)                                                         password_reset#update
#                                       PUT    /password_reset/:token(.:format)                                                         password_reset#update
#          check_publishable_admin_deal GET    /admin/deals/:id/check_publishable(.:format)                                             admin/deals#check_publishable
#                           admin_deals GET    /admin/deals(.:format)                                                                   admin/deals#index
#                                       POST   /admin/deals(.:format)                                                                   admin/deals#create
#                        new_admin_deal GET    /admin/deals/new(.:format)                                                               admin/deals#new
#                       edit_admin_deal GET    /admin/deals/:id/edit(.:format)                                                          admin/deals#edit
#                            admin_deal GET    /admin/deals/:id(.:format)                                                               admin/deals#show
#                                       PATCH  /admin/deals/:id(.:format)                                                               admin/deals#update
#                                       PUT    /admin/deals/:id(.:format)                                                               admin/deals#update
#                                       DELETE /admin/deals/:id(.:format)                                                               admin/deals#destroy
#                           admin_users GET    /admin/users(.:format)                                                                   admin/users#index
#                                       POST   /admin/users(.:format)                                                                   admin/users#create
#                        new_admin_user GET    /admin/users/new(.:format)                                                               admin/users#new
#                       edit_admin_user GET    /admin/users/:id/edit(.:format)                                                          admin/users#edit
#                            admin_user GET    /admin/users/:id(.:format)                                                               admin/users#show
#                                       PATCH  /admin/users/:id(.:format)                                                               admin/users#update
#                                       PUT    /admin/users/:id(.:format)                                                               admin/users#update
#                                       DELETE /admin/users/:id(.:format)                                                               admin/users#destroy
#                                 deals GET    /deals(.:format)                                                                         deals#index
#                                  deal GET    /deals/:id(.:format)                                                                     deals#show
#                                  root        /                                                                                        deals#index
#                                       GET    /*path(.:format)                                                                         redirect(301, /)
#         rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                  action_mailbox/ingresses/mandrill/inbound_emails#create
#         rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                  action_mailbox/ingresses/postmark/inbound_emails#create
#            rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                     action_mailbox/ingresses/relay/inbound_emails#create
#         rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                  action_mailbox/ingresses/sendgrid/inbound_emails#create
#          rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                              action_mailbox/ingresses/mailgun/inbound_emails#create
#        rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                 rails/conductor/action_mailbox/inbound_emails#index
#                                       POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                 rails/conductor/action_mailbox/inbound_emails#create
#     new_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/new(.:format)                             rails/conductor/action_mailbox/inbound_emails#new
#    edit_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id/edit(.:format)                        rails/conductor/action_mailbox/inbound_emails#edit
#         rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#show
#                                       PATCH  /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#update
#                                       PUT    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#update
#                                       DELETE /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#destroy
# rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                      rails/conductor/action_mailbox/reroutes#create
#                    rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#             rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#                    rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#             update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#                  rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  controller :sessions do
    get "login" => :new, as: "login"
    post "login" => :create
    get "logout" => :destroy, as: "logout"
  end
  get 'users/:token/confirm_email', to: 'users#confirm_email', as: 'confirm_email'
  resources :users, only: [:new, :create, :show]
  resources :password_reset, param: :token, only: [:new, :create, :edit, :update]

  namespace :admin do
    resources :deals do
      get 'check_publishable' => 'deals#check_publishable', on: :member
    end
    resources :users
    resources :orders do
      get 'cancel' => 'orders#cancelled', on: :member
      get 'deliver' => 'orders#delivered', on: :member
    end
    controller :reports do
      get 'maximum_potential' => :maximum_potential, as: "maximum_potential"
      get 'minimum_potential' => :minimum_potential, as: "minimum_potential"
      get 'total_revenue' => :total_revenue, as: "total_revenue"
      get 'top_spending_customers' => :top_spending_customers, as: "top_spending_customers"
    end
  end

  resources :deals, only: [:show, :index]
  get 'get_availability' => 'deals#get_availability'
  get 'past_deals' => 'deals#past_deals', as: 'past_deals'

  controller :orders do
    put 'buy_deal' => :add_line_item, as: 'add_line_item'
    get 'checkout' => :checkout, as: 'checkout'
    patch 'place_order' => :place_order, as: 'place_order'
    get 'past_orders' => :past_orders, as: 'past_orders'
  end
  resources :charges

  root 'deals#index', via: :all
  get '*path' => redirect('/')
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
