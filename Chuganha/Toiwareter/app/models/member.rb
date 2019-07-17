# -*- coding: utf-8 -*-
###############################################################################
# モデル：会員
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/06 Nakanohito
# 更新日:
###############################################################################
require 'common/model/db_code_conv_module'
require 'data_cache/authority_cache'
require 'data_cache/member_state_cache'

class Member < ActiveRecord::Base
  include Common::Model::DbCodeConvModule
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :enc_open_id, :member_id, :member_state_id, :authority_id,
                  :enc_nickname, :enc_email,
                  :join_date, :ineligibility_date, :last_login_date, :login_cnt,
                  :quote_cnt, :quote_failure_cnt, :quote_correct_cnt,
                  :quote_correct_failure_cnt, :quote_delete_cnt,
                  :comment_cnt, :comment_failure_cnt, :comment_report_cnt,
                  :were_reported_cnt, :support_report_cnt, :lock_version
  
  #############################################################################
  # Solr設定
  #############################################################################
  searchable do
    text :open_id, :member_id, :nickname
  end
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # OpenID
  def open_id
    return self.dec_value(:enc_open_id)
  end
  
  # ニックネーム
  def nickname
    return self.dec_value(:enc_nickname)
  end
  
  # メールアドレス
  def email
    return self.dec_value(:enc_email)
  end
  
  # 権限
  def authority
    return DataCache::AuthorityCache.instance.id_data(self.authority_id)
  end
  
  # 権限分類
  def authority_cls(authority_cls)
    authority_ent = DataCache::AuthorityCache.instance[authority_cls]
    return if authority_ent.nil?
    self.authority_id = authority_ent.id
  end
  
  # 権限ハッシュ
  def authority_hash
    authority_hash = Hash.new
    authority_hash[:quote_post]     = self.auth_quote_post?
    authority_hash[:quote_update]   = self.auth_quote_update?
    authority_hash[:quote_delete]   = self.auth_quote_delete?
    authority_hash[:comment_post]   = self.auth_comment_post?
    authority_hash[:comment_report] = self.auth_comment_report?
    return authority_hash
  end
  
  # 会員状態
  def member_state
    return DataCache::MemberStateCache.instance.id_data(self.member_state_id)
  end
  
  # 会員状態
  def member_state_cls(member_state_cls)
    state_ent = DataCache::MemberStateCache.instance[member_state_cls]
    return if state_ent.nil?
    self.member_state_id = state_ent.id
  end
  
  # 有効な会員か判定
  def valid_member?
    # 会員状態判定（登録済み）
    return MemberState::MEMBER_STATE_CLS_REGISTERED == member_state.member_state_cls
  end
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :enc_open_id,
    :presence => true
  validates :member_id,
    :presence => true,
    :length => {:is => 10}
  validates :member_state_id,
    :presence => true,
    :numericality => {:only_integer=>true, :greater_than=>0}
  validates :authority_id,
    :presence => true,
    :numericality => {:only_integer=>true, :greater_than=>0}
  validates :enc_nickname,
    :presence => true
#  validates :enc_email,
#    :presence => true
  validates :join_date,
    :presence => true
  validates :last_login_date,
    :presence => true
  validates :login_cnt,
    :presence => true,
    :numericality => {:only_integer=>true, :greater_than_or_equal_to=>0}
  validates :quote_cnt,
    :presence => true,
    :numericality => {:only_integer=>true, :greater_than_or_equal_to=>0}
  validates :quote_failure_cnt,
    :presence => true,
    :numericality => {:only_integer=>true, :greater_than_or_equal_to=>0}
  validates :quote_correct_cnt,
    :presence => true,
    :numericality => {:only_integer=>true, :greater_than_or_equal_to=>0}
  validates :quote_correct_failure_cnt,
    :presence => true,
    :numericality => {:only_integer=>true, :greater_than_or_equal_to=>0}
  validates :quote_delete_cnt,
    :presence => true,
    :numericality => {:only_integer=>true, :greater_than_or_equal_to=>0}
  validates :comment_cnt,
    :presence => true,
    :numericality => {:only_integer=>true, :greater_than_or_equal_to=>0}
  validates :comment_failure_cnt,
    :presence => true,
    :numericality => {:only_integer=>true, :greater_than_or_equal_to=>0}
  validates :comment_report_cnt,
    :presence => true,
    :numericality => {:only_integer=>true, :greater_than_or_equal_to=>0}
  validates :were_reported_cnt,
    :presence => true,
    :numericality => {:only_integer=>true, :greater_than_or_equal_to=>0}
  validates :support_report_cnt,
    :presence => true,
    :numericality => {:only_integer=>true, :greater_than_or_equal_to=>0}
    
  #############################################################################
  # protected定義
  #############################################################################
  protected
  # 管理者判定
  def admin?
    return Authority::AUTHORITY_CLS_ADMIN == self.authority.authority_cls
  end
  
  # 可能性値
  def auth_potential_value
    # ログイン回数 / 10
    return self.login_cnt / 10
  end
  
  # 引用投稿権限
  def auth_quote_post?
    # 管理者判定
    return true if self.admin?
    # 引用過失回数 / (引用投稿回数+可能性ポイント) <= 5%
    return true if self.quote_failure_cnt == 0
    wk_value = self.quote_cnt + self.auth_potential_value
    return true if wk_value == 0
    return (self.quote_failure_cnt.to_f / wk_value.to_f).to_f <= 0.05
  end
  
  # 引用訂正権限
  def auth_quote_update?
    # 管理者判定
    return true if self.admin?
    # ログイン回数 >= 10 かつ
    return false if self.login_cnt < 10
    # 引用投稿権限 かつ
    return false unless self.auth_quote_post?
    # 引用被訂正回数  / 引用投稿回数 <= 10%
    return false if self.quote_correct_failure_cnt == 0 || self.quote_cnt == 0
    return (self.quote_failure_cnt.to_f / self.quote_cnt.to_f).to_f <= 0.1
  end
  
  # 引用削除権限
  def auth_quote_delete?
    # 管理者判定
    return true if self.admin?
    # 引用訂正権限　かつ
    return false unless self.auth_quote_update?
    # 引用削除回数 / 引用投稿回数 <= 20%
    return (self.quote_delete_cnt.to_f / self.quote_cnt.to_f).to_f <= 0.2
  end
  
  # コメント投稿権限
  def auth_comment_post?
    # 管理者判定
    return true if self.admin?
    # コメント過失回数　/　(コメント投稿回数+可能性ポイント) <= 5%
    return true if self.comment_failure_cnt == 0
    wk_value = self.comment_cnt + self.auth_potential_value
    return true if wk_value == 0
    return (self.comment_failure_cnt.to_f / wk_value.to_f).to_f <= 0.05
  end
  
  # コメント通報権限
  def auth_comment_report?
    # 管理者判定
    return true if self.admin?
    # コメント投稿権限　かつ
    return false unless self.auth_comment_post?
    # (コメント通報対応回数+可能性ポイント)/コメント通報回数 >= 5%
    wk_value = self.support_report_cnt + self.auth_potential_value
    return false if wk_value == 0
    return true if self.comment_report_cnt == 0
    return (wk_value.to_f / self.comment_report_cnt.to_f).to_f >= 0.1
  end
  
end
