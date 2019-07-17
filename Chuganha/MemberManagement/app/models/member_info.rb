###############################################################################
# 会員情報クラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/06/25 Nakanohito  (mailto:)
# 更新日:
###############################################################################
class MemberInfo < ActiveRecord::Base
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :login_id,
    :presence => {:message => 'は必須です'},
    :length => {:is => 10, :wrong_length => 'は%{count}桁でなければなりません'}
  validates :member_state_cls,
    :presence => {:message => 'は必須です'},
    :length => {:is => 2, :wrong_length => 'は%{count}桁でなければなりません'}
  validates :authority_cls,
    :presence => {:message => 'は必須です'},
    :length => {:is => 3, :wrong_length => 'は%{count}桁でなければなりません'}
  validates :login_password,
    :presence => {:message => 'は必須です'}
  validates :nickname,
    :presence => {:message => 'は必須です'},
    :length => {:minimum => 1, :too_short => 'は%{count}桁以上でなければなりません',
                :maximum => 20, :too_long => 'は%{count}桁以下でなければなりません',}
  validates :name,
    :presence => {:message => 'は必須です'}
  validates :reading_of_a_name,
    :presence => {:message => 'は必須です'}
  validates :gender_cls,
    :presence => {:message => 'は必須です'}
  validates :birth_date,
    :presence => {:message => 'は必須です'}
  validates :postcode,
    :presence => {:message => 'は必須です'}
  validates :mobile_phone_number,
    :presence => {:message => 'は必須です'}
  validates :mobile_carrier_cd,
    :presence => {:message => 'は必須です'},
    :length => {:is => 2, :wrong_length => 'は%{count}桁でなければなりません'}
  validates :mobile_domain_no,
    :presence => {:message => 'は必須です'},
    :numericality => {:greater_than_or_equal_to => 0,
                      :less_than_or_equal_to => 99}
  validates :mobile_email,
    :presence => {:message => 'は必須です'}
  
  #############################################################################
  # 関連モデル取得
  #############################################################################
  # 会員状態
  def member_state
    unless @member_state then
      @member_state = MemberState.find_by_member_state_cls(member_state_cls)
    end
    return @member_state
  end
  
  # 権限
  def authority
    unless @authority then
      @authority = Authority.find_by_authority_cls(authority_cls)
    end
    return @authority
  end
  
  # 性別
  def gender
    unless @gender then
      @gender = Gender.find_by_gender_cls(gender_cls)
    end
    return @gender
  end
  
  # 郵便番号
  def postcode
    unless @postcode then
      @postcode = Postcode.find_by_postcode(postcode)
    end
    return @postcode
  end
  
  # 携帯キャリア
  def mobile_carrier
    unless @mobile_carrier then
      @mobile_carrier =
        MobileCarrier.where('mobile_carrier_cd = ? and mobile_domain_no = ?',
                            mobile_carrier_cd, mobile_domain_no)
    end
    return @mobile_carrier
  end
  
  # 認証履歴
  def certification_history
    unless @certification_history then
      @certification_history = CertificationHistory.find_all_by_login_id(login_id)
    end
    return @certification_history
  end
  
  # 最新の認証履歴
  def recent_certification_history
    unless @recent_certification_history then
      @recent_certification_history =
        CertificationHistory.find_all_by_login_id(login_id).order('history_no DESC').first
    end
    return @recent_certification_history
  end  
end
