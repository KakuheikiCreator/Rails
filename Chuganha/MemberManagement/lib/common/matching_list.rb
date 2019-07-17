###############################################################################
# マッチングリストクラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/07/12 Nakanohito
# 更新日:
###############################################################################
module Common
  class MatchingList

    ###########################################################################
    # メソッド定義
    ###########################################################################
    # 初期処理
    def initialize(hash_size=2)
      @limit_hash = 1;
      (hash_size - 1).times do
        @limit_hash *= 10
      end
      @maching_hash = Hash.new
    end

    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public

    # 要素の追加
    def push(element)
      hash = make_hash(element.to_s)
      list = @maching_hash[hash]
      if list == nil then
        @maching_hash[hash] = [element]
      else
        list.push(element)
      end
    end

    # 要素の追加（演算子の定義）
    def <<(element)
      push(element)
    end
  
    # 要素の削除
    def delete(element)
      hash = make_hash(element.to_s)
      list = @maching_hash[hash]
      list.delete(element) if list != nil
      @maching_hash.delete(hash) if list.size == 0
    end

    # リストのクリア
    def clear
      @maching_hash = Hash.new
    end

    # 要素の検索
    def include?(val)
      hash = make_hash(val.to_s)
      list = @maching_hash[hash]
      return false if list == nil
      return list.include?(val)
    end

    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected

    # ハッシュコード生成
    def make_hash(str)
      weight = 0
      hash = 0
      str.each_byte do |s|
        weight = 0 if weight > 7
        hash += s * (256 ** weight)
        weight+=1
      end
      return hash % @limit_hash
    end
  end  
end