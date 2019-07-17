###############################################################################
# 認証履歴クラス
# Author::    Nakanohito  (mailto:)
# Copyright:: Copyright (c) 2011 仲務省
###############################################################################
class CertificationHistory < ActiveRecord::Base
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :login_id,
    :presence => {:message => 'は必須です'},
    :length => {:is => 10, :wrong_length => 'は%{count}桁でなければなりません'}
  validates :history_no,
    :presence => {:message => 'は必須です'}
  validates :certification_date,
    :presence => {:message => 'は必須です'}
  validates :ip_address,
    :presence => {:message => 'は必須です'},
    :length => {:minimum => 1, :too_short => 'は%{count}桁以上でなければなりません',
                :maximum => 15, :too_long => 'は%{count}桁以下でなければなりません',}
end
