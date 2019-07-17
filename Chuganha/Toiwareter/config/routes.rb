# -*- coding: utf-8 -*-
###############################################################################
# ルーティング設定
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/11/14 Nakanohito
# 更新日:
###############################################################################

Toiwareter::Application.routes.draw do
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
  root :to => "open_id/rp#index"

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
  
  # OpenID Function
  namespace :open_id do
    match "rp" => "rp#index"
    match "rp/index" => "rp#index"
    post  "rp/start" => "rp#start"
    match "rp/complete" => "rp#complete"
  end
  
  # Admission Function
  namespace :admission do
    match "admission/form" => "admission#form"
    match "admission/register" => "admission#register"
  end
  
  # Member List Function
  namespace :member do
    match "view/:member_id" => "view#index"
    match "home/index" => "home#index"
    match "list/list" => "list#list"
    match "list/search" => "list#search"
    match "update/form" => "update#form"
    match "update/check" => "update#check"
    match "update/update" => "update#update"
  end
  
  # Search Function
  namespace :search do
    match "fulltext" => "fulltext#form"
    match "fulltext/form" => "fulltext#form"
    match "fulltext/quote" => "fulltext#quote"
    match "fulltext/comment" => "fulltext#comment"
    match "detail" => "detail#form"
    match "detail/form" => "detail#form"
    match "detail/quote" => "detail#quote"
    match "detail/source" => "detail#source"
    match "detail/comment" => "detail#comment"
  end
  
  # Quote Function
  namespace :quote do
    match "post/form" => "post#form"
    match "post/source" => "post#source"
    match "post/check" => "post#check"
    match "post/create" => "post#create"
    match "update/form" => "update#form"
    match "update/check" => "update#check"
    match "update/update" => "update#update"
    match "delete/form" => "delete#form"
    match "delete/check" => "delete#check"
    match "delete/delete" => "delete#delete"
    match "view" => "view#index"
    match "view/:quote_id" => "view#index"
  end
  
  # Comment Function
  namespace :comment do
    match "post/check" => "post#check"
    match "post/create" => "post#create"
    match "report/form" => "report#form"
    match "report/check" => "report#check"
    match "report/report" => "report#report"
    match "delete/form" => "delete#form"
    match "delete/check" => "delete#check"
    match "delete/delete" => "delete#delete"
  end
  
  # Report List Function
  namespace :report do
    match "list/list" => "list#list"
    match "list/search" => "list#search"
    match "list/prev" => "list#prev"
    match "list/next" => "list#next"
  end
  
  # NGWord List Function
  namespace :ng_list do
    match "ng_list/list" => "ng_list#list"
    match "ng_list/create" => "ng_list#create"
    match "ng_list/delete" => "ng_list#delete"
  end
  
end
