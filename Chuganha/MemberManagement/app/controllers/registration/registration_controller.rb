# -*- coding: utf-8 -*-
###############################################################################
# 機能：会員登録
# クラス：コントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/18 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_common/biz_document'
require 'biz_actions/registration/step_1_action'
require 'biz_actions/registration/step_2_action'
require 'biz_actions/registration/step_3_action'
require 'biz_actions/registration/step_4_action'
require 'biz_actions/registration/step_5_action'
require 'biz_actions/registration/step_7_action'
require 'biz_actions/registration/check_id_action'
require 'biz_actions/registration/miss_action'
require 'biz_helpers/registration/step_4_helper'
require 'objspace'

class Registration::RegistrationController < ApplicationController
  include Filter::MethodRegulation
  include Filter::UpdateSession
  include BizCommon
  include BizActions::Registration
  include BizHelpers::Registration
  # レイアウト未指定
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST), :except=>['step_1', 'step_7', 'miss']
  around_filter UpdateSessionFilter.new, :except=>['step_1', 'step_7', 'miss']

  # 会員規約確認フォーム表示
  def step_1
    @biz_obj = Step1Action.new(self)
    @page_title = view_text('step_1.item_names.page_titile')
    @page_title_image = 'registration/registration_title.jpg'
    @step_no = 1
    @agreement = BizDocument.instance[:agreement]
    respond_to do |format|
      format.html {
        # ログイン認証チェック
        if @biz_obj.login? then
          # フロントページに遷移
          redirect_to_front
        else
          # 会員規約確認フォーム表示
          render :action=>'step_1', :layout=>'layout_2'
        end
      }
    end
  end
  
  # 個人情報保護方針確認フォーム表示
  def step_2
    @biz_obj = Step2Action.new(self)
    @page_title = view_text('step_2.item_names.page_titile')
    @page_title_image = 'registration/registration_title.jpg'
    @step_no = 2
    @privacy_policy = BizDocument.instance[:privacy_policy]
    respond_to do |format|
      format.html {
        # バリデーションチェック
        if @biz_obj.agreement? then
          render :action=>'step_2', :layout=>'layout_2'
        else
          redirect_to_front
        end
      }
    end
  end
  
  # 会員情報入力フォーム表示
  def step_3
    @biz_obj = Step3Action.new(self)
    @page_title = view_text('step_3.item_names.page_titile')
    @page_title_image = 'registration/registration_title.jpg'
    @err_hash = @biz_obj.error_msg_hash
    @step_no = 3
    respond_to do |format|
      format.html {
        # リダイレクト判定
        if flash[:redirect_flg] then
          render :action=>'step_3', :layout=>'layout_2'
        # バリデーションチェック
        elsif @biz_obj.agreement? then
          render :action=>'step_3', :layout=>'layout_2'
        else
          redirect_to_front
        end
      }
    end
  end
  
  # 会員情報確認フォーム表示
  def step_4
    @biz_obj = Step4Action.new(self)
    @biz_helper = Step4Helper.new(self)
    @page_title = view_text('step_4.item_names.page_titile')
    @page_title_image = 'registration/registration_title.jpg'
    @err_hash = @biz_obj.error_msg_hash
    @step_no = 4
    respond_to do |format|
      format.html {
        # 確認画面表示判定
        if @biz_obj.confirmation_display? then
          render :action=>'step_4', :layout=>'layout_2'
        else
          redirect_to_step_3(@biz_obj)
        end
      }
    end
  end
  
  # 仮登録完了メール送付メッセージ表示
  def step_5
    @biz_obj = Step5Action.new(self)
    @page_title = view_text('step_5.item_names.page_titile')
    @page_title_image = 'registration/registration_title.jpg'
    @step_no = 5
    respond_to do |format|
      format.html {
        # メール送信判定
        if @biz_obj.send_mail? then
          render :action=>'step_5', :layout=>'layout_2'
        else
          redirect_to_step_3(@biz_obj)
        end
      }
    end
  end
  
  # 本登録完了メッセージ表示
  def step_7
    @biz_obj = Step7Action.new(self)
    result_flg = @biz_obj.registration?
    @page_title = view_text('step_7.item_names.page_titile') + result_flg.to_s
    respond_to do |format|
      format.html {render :action=>'step_7', :layout=>'layout_mbl'}
    end
  end
  
  # 誤登録データ削除処理
  def miss
    @biz_obj = MissAction.new(self)
    result_flg = @biz_obj.delete?
    @page_title = view_text('miss.item_names.page_titile') + result_flg.to_s
    #　連絡先アドレス（管理者アドレス）
    @contact_mail = BizCommon::BusinessConfig.instance[:admin_mail]
    respond_to do |format|
      format.html {render :action=>'miss', :layout=>'layout_mbl'}
    end
  end
  
  # ユーザーID存在チェック
  def check_id
    @biz_obj = CheckIDAction.new(self)
#    memsize # メモリサイズチェック
    render :text=>@biz_obj.check_result
  end
  
  #############################################################################
  # protected定義
  #############################################################################
  protected
  # ステップ３にリダイレクト
  def redirect_to_step_3(biz_action)
    params = biz_action.params
    params.update(create_scr_trans_params(self, TRANS_PTN_NOW))
    flash[:redirect_flg] = true
    flash[:params] = params
    flash[:err_hash] = biz_action.error_msg_hash
    redirect_to(:controller=>"registration/registration", :action=>"step_3")
  end
  
  # メモリ使用量取得
  def memsize(klass=false)
    total = 0
#    total += ObjectSpace.memsize_of_all(klass)
    size_hash = Hash.new
    ObjectSpace.each_object(klass) do |obj|
      msize = ObjectSpace.memsize_of(obj)
      total += msize
      size_hash[obj.class.to_s] = 0 if size_hash[obj.class.to_s].nil?
      size_hash[obj.class.to_s] += msize
    end
    size_hash.each_pair do |key, value|
      Rails.logger.debug(key + ':' + value.to_s)
    end
    Rails.logger.debug('Total size:' + total.to_s)
    return total
  end
end
