# -*- coding: utf-8 -*-
###############################################################################
# ルーティング設定
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/12 Nakanohito
# 更新日:
###############################################################################
require 'messaging/test_rack'
require 'messaging/key_sharing_rack'
require 'messaging/msg_receiver_rack'

AccessManagement::Application.routes.draw do
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
  root :to => "login/login#form"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  # Common Function
  namespace :common do
    post  "session/clear" => "session#clear"
    post  "session/sweep" => "session#sweep"
  end
  
  # Login Function
  namespace :login do
    get "login" => "login#form"
    get "login/form" => "login#form"
    post "login/login"=>"login#login"
    post "login/logout"=>"login#logout"
  end
  
  # Menu Function
  namespace :menu do
    match "menu/menu"=>"menu#menu"
  end

  # Access Total Function
  namespace :access_total do
    post "access_total/form"=>"access_total#form"
    post "access_total/totalization"=>"access_total#totalization"
    post "access_total/function"=>"access_total#function"
    post "access_total/browser_version"=>"access_total#browser_version"
  end

  # Schedule List Function
  namespace :schedule_list do
    post "schedule_list/list"=>"schedule_list#list"
    post "schedule_list/create"=>"schedule_list#create"
    post "schedule_list/update"=>"schedule_list#update"
    post "schedule_list/delete"=>"schedule_list#delete"
    post "schedule_list/notify"=>"schedule_list#notify"
  end

  # Regulation Host List Function
  namespace :regulation_host_list do
    post "regulation_host_list/list"=>"regulation_host_list#list"
    post "regulation_host_list/create"=>"regulation_host_list#create"
    post "regulation_host_list/delete"=>"regulation_host_list#delete"
    post "regulation_host_list/notify"=>"regulation_host_list#notify"
  end

  # Regulation Cookie List Function
  namespace :regulation_cookie_list do
    post "regulation_cookie_list/list"=>"regulation_cookie_list#list"
    post "regulation_cookie_list/create"=>"regulation_cookie_list#create"
    post "regulation_cookie_list/delete"=>"regulation_cookie_list#delete"
    post "regulation_cookie_list/notify"=>"regulation_cookie_list#notify"
  end

  # Regulation Referrer Function
  namespace :regulation_referrer_list do
    post "regulation_referrer_list/list"=>"regulation_referrer_list#list"
    post "regulation_referrer_list/create"=>"regulation_referrer_list#create"
    post "regulation_referrer_list/delete"=>"regulation_referrer_list#delete"
    post "regulation_referrer_list/notify"=>"regulation_referrer_list#notify"
  end
  
  # メッセージ受信
  namespace :messaging do
    post "key_sharing"=>Messaging::KeySharingRack.new(Rails.logger)
    post "msg_receiver"=>Messaging::MsgReceiverRack.new(Rails.logger)
  end
end
