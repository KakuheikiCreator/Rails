###############################################################################
# 退会者状態クラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/06/25 Nakanohito  (mailto:)
# 更新日:
###############################################################################
class PeopleLeavingState < ActiveRecord::Base
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :people_leaving_state_cls,
    :presence => {:message => 'は必須です'},
    :length => {:is => 1, :wrong_length => 'は%{count}桁でなければなりません'}
  validates :people_leaving_state,
    :presence => {:message => 'は必須です'},
    :length => {:minimum => 1, :too_short => 'は%{count}桁以上でなければなりません',
                :maximum => 20, :too_long => 'は%{count}桁以下でなければなりません',}
end
