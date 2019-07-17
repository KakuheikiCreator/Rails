# -*- coding: utf-8 -*-
###############################################################################
# アプリケーションコントローラークラス
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/11/14 Nakanohito
# 更新日:
###############################################################################
require 'common/session_util_module'
require 'biz_common/business_config'
require 'filter/access_regulation/access_regulation_filter'
require 'filter/biz_preprocess/biz_preprocess_filter'
require 'filter/request_analysis/request_analysis_module'
require 'filter/set_locale/set_locale_filter'

class ApplicationController < ActionController::Base
  include Common
  include Filter::AccessRegulation
  include Filter::BizPreprocess
  include Filter::RequestAnalysis::RequestAnalysisModule
  include Filter::SetLocale
  
  #############################################################################
  # フィルター処理設定
  #############################################################################
  protect_from_forgery
  before_filter BizPreprocessFilter.new          # 業務前処理フィルタ
  before_filter AccessRegulationFilter.new       # アクセス規制フィルタ
  before_filter :request_analysis                # アクセス解析フィルタ
  before_filter SetLocaleFilter.new              # 言語設定フィルタ
  
  #############################################################################
  # 例外処理設定
  #############################################################################
  # その他のエラー：サーバ内部エラー
  rescue_from(Exception, :with=>:render_500)
  # 404エラー：対象データなし、存在しないアクション
  rescue_from(ActiveRecord::RecordNotFound,
              AbstractController::ActionNotFound, :with=>:render_404)
  # 422エラー：処理できないエンティティ
  rescue_from(ActionController::InvalidAuthenticityToken, :with=>:render_422)
  # 更新データ競合エラー（楽観ロックエラー）
  rescue_from(ActiveRecord::StaleObjectError, :with=>:render_lock_error)

  #############################################################################
  # public定義
  #############################################################################
  public
  # リダイレクト処理のラッパーメソッド
  def redirect_to(*args)
    dest = args[0]
    return super(*args) unless String === dest
    # サブディレクトリ対策
    new_args = args.clone
    new_args[0] = BizCommon::BusinessConfig.instance.root_path + dest
    return super(*new_args)
  end

  # 国際化テキスト生成
  def view_text(key, opts=nil)
    return "" if key.nil?
    return I18n.t('views.' + controller_path.gsub('/', '.') + '.' + key, opts)
  end
  
  def render_403
    render_error(403)
  end
  
  def render_404
    render_error(404)
  end
  
  def render_422
    render_error(422)
  end
  
  def render_500(ex=nil)
    unless ex.nil? then
      logger.error("Exception:" + ex.class.name)
      logger.error("Message  :" + ex.message)
      logger.error("Backtrace:" + ex.backtrace.join("\n"))
    end
    reset_session
    render_error(500)
  end
  
  def render_error(status_code)
    render(:file=>"#{Rails.root}/public/#{status_code}", :status=>status_code, :layout=>false)
  end
  
  # フロントページにリダイレクト
  def redirect_to_front
    redirect_to("/index.html")
  end
  
  # 会員ホームにリダイレクト
  def redirect_to_home(member_id=nil)
    flash[:redirect_flg] = true
    send_params =
      SessionUtilModule.create_scr_trans_params(self, SessionUtilModule::TRANS_PTN_CLH)
    send_params[:member_id] = member_id
    flash[:params] = send_params
    redirect_to(:controller=>"member/home", :action=>"index")
  end
  
  # 引用表示にリダイレクト
  def redirect_to_quote(quote_id, add_params=nil)
    flash[:redirect_flg] = true
    send_params =
      SessionUtilModule.create_scr_trans_params(self, SessionUtilModule::TRANS_PTN_CLH)
    send_params.update(add_params) if Hash === add_params
    send_params[:quote_id] = quote_id.to_s
    flash[:params] = send_params
    redirect_to(:controller=>"quote/view")
  end
end
