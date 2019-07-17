# -*- coding: utf-8 -*-
###############################################################################
# ルーティング設定
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/17 Nakanohito
# 更新日:
###############################################################################

MemberManagement::Application.routes.draw do
  get "withdrawal/form"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  root :to => "session/session#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  # Common Function
  namespace :common do
    post  "session/clear" => "session#clear"
    post  "session/logout" => "session#logout"
    post  "session/sweep" => "session#sweep"
  end
  
  # OpenID
  namespace :open_id do
    match "" => "op#index"
    match 'xrds' => 'op#idp_xrds'
    match "index" => "op#index"
    match "confirmation_form" => "op#confirmation_form"
    match "confirmation" => "op#confirmation"
    match 'user/:user_id' => 'op#user_page'
    match 'user/:user_id/xrds' => 'op#user_xrds'
  end
  
  # 会員登録
  namespace :registration do
    get  "step_1" => "registration#step_1"
    post "step_2" => "registration#step_2"
    match "step_3" => "registration#step_3"
    post "step_4" => "registration#step_4"
    post "step_5" => "registration#step_5"
    get  "step_7" => "registration#step_7"
    get  "miss" => "registration#miss"
    post "check_id" => "registration#check_id"
  end
  
  # ログイン・ログアウト
  namespace :session do
    match "" => "session#index"
    match "index" => "session#index"
    match "login" => "session#login"
    match "logout" => "session#logout"
  end
  
  # 会員ホーム
  namespace :home do
    match "home" => "home#home"
  end
  
  # 会員情報更新
  namespace :update do
    match "form" => "update#form"
    match "confirmation" => "update#confirmation"
    match "update" => "update#update"
    get "complete" => "update#complete"
    get "miss" => "update#miss"
  end
  
  # 退会処理
  namespace :withdrawal do
    match "form" => "withdrawal#form"
    match "confirmation" => "withdrawal#confirmation"
    match "withdrawal" => "withdrawal#withdrawal"
  end
  
  # 会員リスト
  namespace :list do
    match "form" => "list#form"
    match "search" => "list#search"
  end
  
end
