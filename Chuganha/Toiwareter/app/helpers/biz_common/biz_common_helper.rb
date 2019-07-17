# -*- coding: utf-8 -*-
###############################################################################
# クラス：業務共通ヘルパー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/12 Nakanohito
# 更新日:
###############################################################################
require 'data_cache/job_title_cache'
require 'data_cache/source_cache'
require 'data_cache/bbs_cache'
require 'data_cache/game_console_cache'
require 'data_cache/newspaper_cache'
require 'data_cache/sns_cache'
require 'data_cache/report_reason_cache'
require 'data_cache/delete_reason_cache'
require 'data_cache/ng_word_cache'

module BizCommon::BizCommonHelper
  # 著作権表記
  def copyright_notation(opts=nil)
    strong = content_tag(:strong, link_to('(C) 2013 仲観派 All Rights Reserved.', 'mailto:chukanha@live.jp'))
    return content_tag(:font, strong, opts)
  end
  
  # ログイン済み判定
  def user_login?
    return !session[:member_id].nil?
  end
  
  # 管理者判定
  def user_admin?
    return Authority::AUTHORITY_CLS_ADMIN == session[:authority_cls]
  end
  
  # 引用投稿権限判定
  def quote_post?
    return session[:authority_hash][:quote_post]
  end
  
  # 引用訂正権限判定
  def quote_update?(quote_ent=nil)
    return true if session[:authority_hash][:quote_update]
    if Quote === quote_ent then
      return true if session[:member_id] == quote_ent.registered_member_id
      return true if session[:member_id] == quote_ent.update_member_id
    end
    return false
  end
  
  # 引用削除権限判定
  def quote_delete?(quote_ent=nil)
    return true if session[:authority_hash][:quote_delete]
    if Quote === quote_ent then
      return true if session[:member_id] == quote_ent.registered_member_id
    end
    return false
  end
  
  # コメント投稿権限判定
  def comment_post?
    return session[:authority_hash][:comment_post]
  end
  
  # コメント通報権限判定
  def comment_report?(comment_ent=nil)
    return true if session[:authority_hash][:comment_report]
    if Comment === comment_ent then
      return true if session[:member_id] != comment_ent.critic_member_id
    end
    return false
  end
  
  # コメント削除権限判定
  def comment_delete?(comment_ent=nil)
    return true if user_admin?
    if Comment === comment_ent then
      return true if session[:member_id] == comment_ent.critic_member_id
    end
    return false
  end
  
  # ログイン済みユーザーのポストリクエスト判定
  def member_post?
    return false if session[:member_id].nil?
    return true if request.request_method == 'POST'
    return request.flash[:redirect_flg] == true
  end
  
  # 肩書き名
  def job_title_name(job_title_id)
    job_title_ent = DataCache::JobTitleCache.instance[job_title_id.to_i]
    return '' if job_title_ent.nil?
    return job_title_ent.job_title
  rescue StandardError => ex
    return ''
  end
  
  # 肩書き名コンボボックス
  def job_title_select(name, job_title_id, opts={})
    job_title_ents = DataCache::JobTitleCache.instance.job_title_list
    return ent_select_tag(name, job_title_ents, :id, :job_title, job_title_id, opts)
  end
  
  # 出所名
  def source_name(source_id)
    source_ent = DataCache::SourceCache.instance[source_id.to_i]
    return '' if source_ent.nil?
    return source_ent.source
  rescue StandardError => ex
    return ''
  end
  
  # 出所名コンボボックス
  def source_select(name, source_id, opts={})
    source_ents = DataCache::SourceCache.instance.source_list
    return ent_select_tag(name, source_ents, :id, :source, source_id, opts)
  end
  
  # 掲示板名
  def bbs_name(bbs_id)
    bbs_ent = DataCache::BbsCache.instance[bbs_id.to_i]
    return '' if bbs_ent.nil?
    return bbs_ent.bbs_name
  rescue StandardError => ex
    return ''
  end
  
  # 出所名コンボボックス
  def bbs_select(name, bbs_id, opts={})
    bbs_ents = DataCache::BbsCache.instance.bbs_list
    return ent_select_tag(name, bbs_ents, :id, :bbs_name, bbs_id, opts)
  end
  
  # ゲーム機名
  def game_console_name(game_console_id)
    game_console_ent = DataCache::GameConsoleCache.instance[game_console_id.to_i]
    return '' if game_console_ent.nil?
    return game_console_ent.game_console_name
  rescue StandardError => ex
    return ''
  end
  
  # ゲーム機名コンボボックス
  def game_console_select(name, game_console_id, opts={})
    game_console_ents = DataCache::GameConsoleCache.instance.game_console_list
    return ent_select_tag(name, game_console_ents, :id, :game_console_name, game_console_id, opts)
  end
  
  # 新聞名
  def newspaper_name(newspaper_id)
    newspaper_ent = DataCache::NewspaperCache.instance[newspaper_id.to_i]
    return '' if newspaper_ent.nil?
    return newspaper_ent.newspaper_name
  rescue StandardError => ex
    return ''
  end
  
  # 新聞名コンボボックス
  def newspaper_select(name, newspaper_id, opts={})
    newspaper_ents = DataCache::NewspaperCache.instance.newspaper_list
    return ent_select_tag(name, newspaper_ents, :id, :newspaper_name, newspaper_id, opts)
  end
  
  # SNS名
  def sns_name(sns_id)
    sns_ent = DataCache::SnsCache.instance[sns_id.to_i]
    return '' if sns_ent.nil?
    return sns_ent.sns_name
  rescue StandardError => ex
    return ''
  end
  
  # SNS名コンボボックス
  def sns_select(name, sns_id, opts={})
    sns_ents = DataCache::SnsCache.instance.sns_list
    return ent_select_tag(name, sns_ents, :id, :sns_name, sns_id, opts)
  end
  
  # 通報理由
  def report_reason(report_reason_id)
    ent = DataCache::ReportReasonCache.instance[report_reason_id.to_i]
    return '' if ent.nil?
    return ent.report_reason
  rescue StandardError => ex
    return ''
  end
  
  # 通報理由コンボボックス
  def report_reason_select(name, report_reason_id, opts={})
    ents = DataCache::ReportReasonCache.instance.report_reason_list
    return ent_select_tag(name, ents, :id, :report_reason, report_reason_id, opts)
  end
  
  # 削除理由
  def delete_reason(delete_reason_id)
    ent = DataCache::DeleteReasonCache.instance[delete_reason_id.to_i]
    return '' if ent.nil?
    return ent.delete_reason
  rescue StandardError => ex
    return ''
  end
  
  # 削除理由コンボボックス
  def delete_reason_select(name, delete_reason_id, opts={})
    ents = DataCache::DeleteReasonCache.instance.delete_reason_list
    return ent_select_tag(name, ents, :id, :delete_reason, delete_reason_id, opts)
  end
  
  # NGワード置き換え
  def replace_ng(sentence)
    return DataCache::NgWordCache.instance.replacement(sentence)
  end

end
