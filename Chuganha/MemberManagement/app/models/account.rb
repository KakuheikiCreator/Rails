# -*- coding: utf-8 -*-
###############################################################################
# モデル：アカウント
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/10/31 Nakanohito
# 更新日:
###############################################################################
require 'validators/ip_address_validator'
require 'validators/uri_validator'
require 'common/model/db_code_conv_module'
require 'data_cache/member_state_cache'
require 'data_cache/authority_cache'
require 'data_cache/gender_cache'
require 'data_cache/language_cache'

class Account < ActiveRecord::Base
  include Validators
  include Common::Model::DbCodeConvModule
  include DataCache
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :user_id, :hsh_password, :member_state_id, :enc_authority_cls,
                  :enc_email, :join_date, :hsh_temp_password,
                  :last_auth_seq_no, :consecutive_failure_cnt, 
                  :enc_last_name, :enc_first_name, :enc_yomigana_last, :enc_yomigana_first,
                  :enc_gender_cls, :enc_birth_date, :salt, :delete_flg, :lock_version
  
  #############################################################################
  # リレーション設定
  #############################################################################
  # ペルソナ
  has_many :persona
  # 認証履歴
  has_many :authentication_history, :order=>'seq_no ASC'
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :user_id,
    :presence => true,
    :length => {:maximum => 32}
  validates :hsh_password,
    :presence => true,
    :length => {:is => 32}
  validates :member_state_id,
    :presence => true
  validates :enc_authority_cls,
    :presence => true
  validates :hsh_temp_password,
    :allow_nil => true,
    :length => {:is => 32}
  validates :consecutive_failure_cnt,
    :presence => true
  validates :enc_last_name,
    :presence => true
  validates :enc_first_name,
    :presence => true
  validates :enc_yomigana_last,
    :presence => true
  validates :enc_yomigana_first,
    :presence => true
  validates :enc_gender_cls,
    :presence => true
  validates :enc_birth_date,
    :presence => true
  validates :salt,
    :presence => true
  
  #############################################################################
  # 検索条件定義
  #############################################################################
  # 重複データ検索
  scope :duplicate, lambda { |ent|
    where(ent.generate_duplicate_condition)
  }

  #############################################################################
  # public定義
  #############################################################################
  public
  # 会員状態取得
  def member_state
    state_id = self.member_state_id
    return nil if state_id.nil?
    return MemberStateCache.instance.id_data(state_id)
  end
  
  # 権限取得
  def authority
    authority_cls = self.dec_value(:enc_authority_cls)
    return nil if authority_cls.nil?
    return AuthorityCache.instance[authority_cls]
  end
  
  # 性別取得
  def gender
    gender_cls = self.dec_value(:enc_gender_cls)
    return nil if gender_cls.nil?
    return GenderCache.instance[gender_cls]
  end
  
  # 最終認証履歴
  def last_auth_history
    last_seq = self.last_auth_seq_no
    return nil if last_seq.nil?
    return self.authentication_history.where(:seq_no=>last_seq)
  end
  
  # 認証結果処理
  def auth_result(auth_flg, lock_threshold)
    if auth_flg then
      self.last_auth_seq_no ||= 0
      self.last_auth_seq_no += 1
      self.consecutive_failure_cnt = 0
    else
      self.consecutive_failure_cnt += 1
      if self.consecutive_failure_cnt <= lock_threshold then
        if self.consecutive_failure_cnt == lock_threshold then
          cache = MemberStateCache.instance
          member_state_id = cache[MemberState::MEMBER_STATE_CLS_STOP].id
        end
        self.last_auth_seq_no ||= 0
        self.last_auth_seq_no += 1
      end
    end
  end
  
  # 最も古い認証履歴の削除
  def del_auth_history
    del_ents = self.authentication_history.order('seq_no ASC').limit(1)
    del_ents[0].destroy unless del_ents.empty?
  end
  
  # 重複データ検索条件生成
  def generate_duplicate_condition
    return {:user_id=>user_id}
  end
  
  # フルネーム生成
  def fullname
    language_cache = LanguageCache.instance
    language = language_cache[self.persona[0].dec_value(:enc_lang_name_cd)]
    # 名前ヨミガナ設定
    if language.name_notation_cls == Language::NOTATION_CLS_LF then
      return self.dec_value(:enc_last_name) + '　' + self.dec_value(:enc_first_name)
    else
      return self.dec_value(:enc_first_name) + '　' + self.dec_value(:enc_last_name)
    end
  end
end
