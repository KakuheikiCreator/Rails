# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ドメインキャッシュクラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/08/17 Nakanohito
# 更新日:
###############################################################################
require 'data_cache/domain_cache'
require 'date'
require 'test_helper'
require 'unit/unit_test_util'

class DomainCacheTest < ActiveSupport::TestCase
  include UnitTestUtil
  include DataCache
  # 前処理
  def setup
    
  end
  # 後処理
  def teardown
    
  end
  # パラメータクラステスト
  test "2-1:DomainParameter Test" do
    # コンストラクタ(正常：ホスト名)
    begin
      test_time = Time.now
      param = DomainCache::DomainParameter.new('infoweb.ne.jp', test_time)
      assert(param.date_confirmed == (test_time - 1), "CASE:2-1-3")
      assert(param.fixed?, "CASE:2-1-4")
      assert(param.move_next?, "CASE:2-1-4")
      assert(!param.fixed?, "CASE:2-1-4")
      assert(test_time == param.standard_time, "CASE:2-1-1,2-1-5")
      param = DomainCache::DomainParameter.new('infoweb.ne.jp')
      assert(param.date_confirmed == (param.standard_time - 1), "CASE:2-1-3")
      assert(param.fixed?, "CASE:2-1-4")
      assert(param.move_next?, "CASE:2-1-4")
      assert(!param.fixed?, "CASE:2-1-4")
      assert(test_time <= param.standard_time, "CASE:2-1-1,2-1-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-1 -> 2-1-5")
    end
    # コンストラクタ(正常：ドメイン)
    begin
      info = Domain.new
      info.domain_name = 'infoweb.ne.jp'
      info.domain_class = Domain::DOMAIN_CLASS_FIXED
      info.date_confirmed = Time.now
      test_time = Time.now - 1
      param = DomainCache::DomainParameter.new(info, test_time)
      assert(info.date_confirmed == param.date_confirmed, "CASE:2-1-3")
      assert(param.fixed?, "CASE:2-1-4")
      assert(param.move_next?, "CASE:2-1-4")
      assert(param.fixed?, "CASE:2-1-4")
      assert(test_time == param.standard_time, "CASE:2-1-2,2-1-5")
      info.domain_class = Domain::DOMAIN_CLASS_OTHER
      param = DomainCache::DomainParameter.new(info)
      assert(info.date_confirmed == param.date_confirmed, "CASE:2-1-3")
      assert(param.fixed?, "CASE:2-1-4")
      assert(param.move_next?, "CASE:2-1-4")
      assert(!param.fixed?, "CASE:2-1-4")
      assert(test_time < param.standard_time, "CASE:2-1-2,2-1-5")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-2")
    end
    # フレーズの移動（ホスト名）
    begin
      info = Domain.new
      info.domain_name = 'infoweb.ne.jp'
      info.domain_class = Domain::DOMAIN_CLASS_OTHER
      info.date_confirmed = Time.now
      param = DomainCache::DomainParameter.new(info)
      assert(param.current_phrase == 'jp', "CASE:2-1-6")
      assert(!param.move_before?, "CASE:2-1-8")
      assert(param.current_phrase == 'jp', "CASE:2-1-6")
      assert(param.move_next?, "CASE:2-1-9")
      assert(param.current_phrase == 'ne', "CASE:2-1-6")
      assert(param.move_next?, "CASE:2-1-9")
      assert(param.current_phrase == 'infoweb', "CASE:2-1-6")
      assert(!param.move_next?, "CASE:2-1-10")
      assert(param.current_phrase == 'infoweb', "CASE:2-1-6")
      assert(param.move_before?, "CASE:2-1-7")
      assert(param.current_phrase == 'ne', "CASE:2-1-6")
      assert(param.move_before?, "CASE:2-1-7")
      assert(param.current_phrase == 'jp', "CASE:2-1-6")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-6 -> 2-1-10")
    end
    # フレーズの移動（ドメイン）
    begin
      test_time = Time.now
      param = DomainCache::DomainParameter.new('infoweb.ne.jp', test_time)
      assert(param.current_phrase == 'jp', "CASE:2-1-6")
      assert(!param.move_before?, "CASE:2-1-8")
      assert(param.current_phrase == 'jp', "CASE:2-1-6")
      assert(param.move_next?, "CASE:2-1-9")
      assert(param.current_phrase == 'ne', "CASE:2-1-6")
      assert(param.move_next?, "CASE:2-1-9")
      assert(param.current_phrase == 'infoweb', "CASE:2-1-6")
      assert(!param.move_next?, "CASE:2-1-10")
      assert(param.current_phrase == 'infoweb', "CASE:2-1-6")
      assert(param.move_before?, "CASE:2-1-7")
      assert(param.current_phrase == 'ne', "CASE:2-1-6")
      assert(param.move_before?, "CASE:2-1-7")
      assert(param.current_phrase == 'jp', "CASE:2-1-6")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-1-6 -> 2-1-10")
    end
  end
  
  # ツリーノードクラステスト：コンストラクタ
  test "2-2:DomainTreeNode Test:initialize" do
    # コンストラクタ（ホスト名設定パラメータ）
    begin
      test_time = Time.now
      param = DomainCache::DomainParameter.new('infoweb.ne.jp', test_time)
      tld_node = DomainCache::DomainTreeNode.new(param)
      assert(!tld_node.nil?, "CASE:2-2-1")
      assert(tld_node.node_class == DomainCache::DomainTreeNode::CLASS_FIXED, "CASE:2-2-1")
      param.move_next?
      sub_node = DomainCache::DomainTreeNode.new(param, tld_node)
      assert(sub_node.node_class == DomainCache::DomainTreeNode::CLASS_DOMAIN, "CASE:2-2-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # コンストラクタ（ドメイン設定パラメータ:有効期限切れ、固定ドメイン）
    begin
      info = Domain.new
      info.domain_name = 'infoweb.ne.jp'
      info.domain_class = Domain::DOMAIN_CLASS_FIXED
      info.date_confirmed = Time.now - 1
      test_time = Time.now
      param = DomainCache::DomainParameter.new(info, test_time)
      tld_node = DomainCache::DomainTreeNode.new(param)
      assert(!tld_node.nil?, "CASE:2-2-3")
      assert(tld_node.node_class == DomainCache::DomainTreeNode::CLASS_FIXED, "CASE:2-2-3")
      param.move_next?
      sub_node = DomainCache::DomainTreeNode.new(param, tld_node)
      assert(sub_node.node_class == DomainCache::DomainTreeNode::CLASS_FIXED, "CASE:2-2-4")
      param.move_next?
      last_node = DomainCache::DomainTreeNode.new(param, sub_node)
#      print("Node Class:", last_node.node_class, "\n")
      assert(last_node.node_class == DomainCache::DomainTreeNode::CLASS_FIXED, "CASE:2-2-4")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # コンストラクタ（ドメイン設定パラメータ:有効期限内）
    begin
      info = Domain.new
      info.domain_name = 'infoweb.ne.jp'
      info.domain_class = Domain::DOMAIN_CLASS_OTHER
      info.date_confirmed = Time.now
      test_time = Time.now - 1
      param = DomainCache::DomainParameter.new(info, test_time)
      tld_node = DomainCache::DomainTreeNode.new(param)
      assert(!tld_node.nil?, "CASE:2-2-5")
      assert(tld_node.node_class == DomainCache::DomainTreeNode::CLASS_FIXED, "CASE:2-2-5")
      param.move_next?
      sub_node = DomainCache::DomainTreeNode.new(param, tld_node)
      assert(sub_node.node_class == DomainCache::DomainTreeNode::CLASS_DOMAIN, "CASE:2-2-6")
      param.move_next?
      last_node = DomainCache::DomainTreeNode.new(param, sub_node)
#      print("Node Class:", last_node.node_class, "\n")
      assert(last_node.node_class == DomainCache::DomainTreeNode::CLASS_DOMAIN, "CASE:2-2-6")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # コンストラクタ（ドメイン設定パラメータ:有効期限切）
    begin
      info = Domain.new
      info.domain_name = 'infoweb.ne.jp'
      info.domain_class = Domain::DOMAIN_CLASS_OTHER
      info.date_confirmed = Time.now - 1
      test_time = Time.now
      param = DomainCache::DomainParameter.new(info, test_time)
      tld_node = DomainCache::DomainTreeNode.new(param)
      assert(!tld_node.nil?, "CASE:2-2-7")
      assert(tld_node.node_class == DomainCache::DomainTreeNode::CLASS_FIXED, "CASE:2-2-7")
      param.move_next?
      sub_node = DomainCache::DomainTreeNode.new(param, tld_node)
      assert(sub_node.node_class == DomainCache::DomainTreeNode::CLASS_DOMAIN, "CASE:2-2-8")
      param.move_next?
      last_node = DomainCache::DomainTreeNode.new(param, sub_node)
#      print("Node Class:", last_node.node_class, "\n")
      assert(last_node.node_class == DomainCache::DomainTreeNode::CLASS_DOMAIN, "CASE:2-2-8")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # コンストラクタ（ドメイン設定パラメータ:有効期限切、存在しないドメイン）
    begin
      info = Domain.new
      info.domain_name = 'sonzaisinai.ne.jp'
      info.domain_class = Domain::DOMAIN_CLASS_OTHER
      info.date_confirmed = Time.now - 1
      test_time = Time.now
      param = DomainCache::DomainParameter.new(info, test_time)
      tld_node = DomainCache::DomainTreeNode.new(param)
      assert(!tld_node.nil?, "CASE:2-2-9")
      assert(tld_node.node_class == DomainCache::DomainTreeNode::CLASS_FIXED, "CASE:2-2-9")
      param.move_next?
      sub_node = DomainCache::DomainTreeNode.new(param, tld_node)
      assert(sub_node.node_class == DomainCache::DomainTreeNode::CLASS_DOMAIN, "CASE:2-2-10")
      param.move_next?
      last_node = DomainCache::DomainTreeNode.new(param, sub_node)
#      print("Test Domain Name:", last_node.generate_domain_name, "\n")
#      print("Test Node Class:", last_node.node_class, "\n")
#      print("Test date_confirmed:", last_node.date_confirmed, "\n")
      assert(last_node.node_class == DomainCache::DomainTreeNode::CLASS_NOT_EXIST, "CASE:2-2-10")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
  
  # ツリーノードクラステスト：ノード追加
  test "2-3:DomainTreeNode Test:add_node" do
    # コンストラクタ（ホスト名設定パラメータ）
    begin
      test_time = Time.now
      param = DomainCache::DomainParameter.new('infoweb.ne.jp', test_time)
      tld_node = DomainCache::DomainTreeNode.new(param)
      add_node = tld_node.add_node(param)
      node = tld_node.node_search(param)
      assert(node == add_node, "CASE:2-3-1,2-4-2")
      assert(node.phrase == 'infoweb', "CASE:2-3-1,2-4-1")
      assert(node.generate_domain_name == 'infoweb.ne.jp', "CASE:2-3-1,2-4-1,2-5-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # コンストラクタ（ドメイン設定パラメータ:有効期限切れ、固定ドメイン）
    begin
      info = Domain.new
      info.id = 10000
      info.domain_name = 'infoweb.ne.jp'
      info.domain_class = Domain::DOMAIN_CLASS_FIXED
      info.date_confirmed = Time.now - 1
      test_time = Time.now
      param = DomainCache::DomainParameter.new(info, test_time)
      tld_node = DomainCache::DomainTreeNode.new(param)
      add_node = tld_node.add_node(param)
      param = DomainCache::DomainParameter.new('nfmv001061082.uqw.ppp.infoweb.ne.jp', test_time)
      node = tld_node.node_search(param)
      assert(node == add_node, "CASE:2-3-2,2-4-2")
      assert(node.phrase == 'infoweb', "CASE:2-3-2,2-4-2")
      assert(node.domain_id == info.id, "CASE:2-3-2,2-4-2")
      assert(node.generate_domain_name == 'infoweb.ne.jp', "CASE:2-3-2,2-4-2,2-5-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # コンストラクタ（ドメイン設定パラメータ:有効期限内）
    begin
      info = Domain.new
      info.domain_name = 'infoweb.ne.jp'
      info.domain_class = Domain::DOMAIN_CLASS_OTHER
      info.date_confirmed = Time.now
      test_time = Time.now - 1
      param = DomainCache::DomainParameter.new(info, test_time)
      tld_node = DomainCache::DomainTreeNode.new(param)
      add_node = tld_node.add_node(param)
      param = DomainCache::DomainParameter.new('nfmv001061082.uqw.ppp.infoweb.ne.jp', test_time)
      node = tld_node.node_search(param)
      assert(node == add_node, "CASE:2-3-3,2-4-2")
      assert(node.phrase == 'infoweb', "CASE:2-3-3,2-4-2")
      assert(node.generate_domain_name == 'infoweb.ne.jp', "CASE:2-3-3,2-4-2,2-5-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # コンストラクタ（ドメイン設定パラメータ:有効期限切）
    begin
      test_time = Time.now
      info = Domain.new
      info.domain_name = 'infoweb.ne.jp'
      info.domain_class = Domain::DOMAIN_CLASS_OTHER
      info.date_confirmed = Time.now - 2
      test_time = Time.now - 1
      param = DomainCache::DomainParameter.new(info, test_time)
      tld_node = DomainCache::DomainTreeNode.new(param)
      add_node = tld_node.add_node(param)
      param = DomainCache::DomainParameter.new('nfmv001061082.uqw.ppp.infoweb.ne.jp', test_time)
      node = tld_node.node_search(param)
      assert(node == add_node, "CASE:2-3-4,2-4-2")
      assert(node.phrase == 'infoweb', "CASE:2-3-4,2-4-2")
      assert(node.generate_domain_name == 'infoweb.ne.jp', "CASE:2-3-4,2-4-2,2-5-1")
      assert(node.date_confirmed > test_time, "CASE:2-3-4,2-4-2,2-5-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # コンストラクタ（ドメイン設定パラメータ:有効期限切、存在しないドメイン）
    begin
      test_time = Time.now
      info = Domain.new
      info.domain_name = 'sonzaisinai.ne.jp'
      info.domain_class = Domain::DOMAIN_CLASS_OTHER
      info.date_confirmed = Time.now - 2
      test_time = Time.now - 1
      param = DomainCache::DomainParameter.new(info, test_time)
      tld_node = DomainCache::DomainTreeNode.new(param)
      add_node = tld_node.add_node(param)
      param = DomainCache::DomainParameter.new('nfmv001061082.uqw.ppp.sonzaisinai.ne.jp', test_time)
      node = tld_node.node_search(param)
      assert(node == add_node, "CASE:2-3-5,2-4-2")
      assert(node.phrase == 'ne', "CASE:2-3-5,2-4-2")
      assert(node.generate_domain_name == 'ne.jp', "CASE:2-3-5,2-4-2,2-5-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
  
  # ツリーノードクラステスト：ドメイン検索
  test "2-4:DomainTreeNode Test:node_search" do
    # 存在しないドメイン名で検索
    begin
      info = Domain.new
      info.domain_name = 'sonzaisinai.ne.jp'
      info.domain_class = Domain::DOMAIN_CLASS_OTHER
      info.date_confirmed = Time.now
      test_time = Time.now - 1
      param = DomainCache::DomainParameter.new(info, test_time)
      tld_node = DomainCache::DomainTreeNode.new(param)
      add_node = tld_node.add_node(param)
      param = DomainCache::DomainParameter.new('nfmv001061082.uqw.ppp.sonzaisinai.no.jp', test_time)
      node = tld_node.node_search(param)
#      print("Search Node:", node, "\n")
      assert(node == tld_node, "CASE:2-4-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      flunk("CASE:2-4-3")
    end
  end
  
  # ツリーノードクラステスト：データベースアクセス
  test "2-6:DomainTreeNode Test:DB Access" do
#    begin
#      test_time = Time.now
#      info = Domain.new
#      info.date_confirmed = test_time
#      print("1.test_time:", test_time, "\n")
#      print("1.date_confirmed:", info.date_confirmed, "\n")
#    rescue => ex
#      print("Exception:", ex.class.name, "\n")
#      print("Message  :", ex.message, "\n")
#      raise ex
#    end
    # 存在するドメイン名を追加
    begin
      domain_name = 'rakuten.co.jp'
      test_time = Time.now
      param = DomainCache::DomainParameter.new(domain_name, test_time)
      tld_node = DomainCache::DomainTreeNode.new(param)
      node = tld_node.add_node(param)
      # ドメイン登録
      domain = Domain.where(:domain_name => domain_name)[0]
      test_time = Time.local(test_time.year, test_time.mon, test_time.day,
                             test_time.hour, test_time.min, test_time.sec)
      assert(domain.date_confirmed >= test_time, "CASE:2-6-1")
      assert(!domain.delete_flg, "CASE:2-6-1")
      assert(domain.created_at >= test_time, "CASE:2-6-1")
      assert(domain.updated_at >= test_time, "CASE:2-6-1")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    sleep 1
    # 存在するドメイン名を更新（データ登録済み）
    begin
      domain_name = 'rakuten.co.jp'
      test_time = Time.now
      param = DomainCache::DomainParameter.new(domain_name, test_time)
      tld_node = DomainCache::DomainTreeNode.new(param)
      node = tld_node.add_node(param)
      # ドメイン登録
      domain = Domain.where(:domain_name => domain_name)[0]
      test_time = Time.local(test_time.year, test_time.mon, test_time.day,
                             test_time.hour, test_time.min, test_time.sec)
      assert(domain.date_confirmed >= test_time, "CASE:2-6-2")
      assert(!domain.delete_flg, "CASE:2-6-2")
      assert(domain.created_at < test_time, "CASE:2-6-2")
      assert(domain.updated_at >= test_time, "CASE:2-6-2")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # 存在しないドメイン名を追加
    begin
      domain_name = 'logical.delete.ne.jp'
#      domain_name = 'delete.ne.jp'
      test_time = Time.now
#      print("\n")
#      print("test_time     :", test_time.utc?, ":", test_time, "\n")
#      print("test_time     :", test_time.usec, "\n")
      param = DomainCache::DomainParameter.new(domain_name, test_time)
      tld_node = DomainCache::DomainTreeNode.new(param)
      node = tld_node.add_node(param)
#      print("Search Node:", node, "\n")
#      print("Delta1        :", test_time - node.date_confirmed, "\n")
#      assert(node.generate_domain_name == 'ne.jp', "CASE:2-6-3")
      # ドメイン論理削除
      domain = Domain.where(:domain_name => domain_name)[0]
#      test_time_str = test_time.instance_eval { '%s.%03d' % [strftime('%Y%m%d%H%M%S'), (usec / 1000.0).round] }
#      print("test_time     :", test_time_str, "\n")
#      updated_at = domain.updated_at.instance_eval { '%s.%03d' % [strftime('%Y%m%d%H%M%S'), (usec / 1000.0).round] }
#      print("updated_at    :", updated_at, "\n")
#      print("domain_name   :", domain.domain_name, "\n")
#      print("date_confirmed:", domain.date_confirmed.utc?, ":", domain.date_confirmed, "\n")
#      print("updated_at    :", domain.updated_at.utc?, ":", domain.updated_at, "\n")
#      print("Delta2        :", test_time - domain.date_confirmed, "\n")
      test_time = Time.local(test_time.year, test_time.mon, test_time.day,
                             test_time.hour, test_time.min, test_time.sec)
      assert(domain.date_confirmed >= test_time, "CASE:2-6-3-1")
      assert(domain.delete_flg, "CASE:2-6-3-2")
      assert(domain.updated_at >= test_time, "CASE:2-6-3-3")
    rescue StandardError => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
  
  # ツリーノードクラステスト：ドメイン検索
  test "2-7:Performance Test:node_search" do
#    flunk("CASE:3-1 No Execute")
    ###########################################################################
    # ドメイン名リスト生成
    ###########################################################################
    size = 1000
    max_depth = 6
    domain_name_list = Array.new
    while domain_name_list.size < size do
      domain_name_list.push(create_domain_name(max_depth))
    end
    print("\n")
    print("Domain Name List Size     :", domain_name_list.size, "\n")
    print("Domain Name List Uniq Size:", domain_name_list.uniq.size, "\n")
    ###########################################################################
    # ドメインツリーの生成
    ###########################################################################
    start_time = Time.now
    tld_node = create_tree(domain_name_list)
    process_time = Time.now - start_time
    print("Load Processing time:", process_time, " second\n")
    ###########################################################################
    # ドメインノードの検索
    ###########################################################################
    max_idx = domain_name_list.size - 1
    start_time = Time.now
    begin
      1000.times do
        domain_name = domain_name_list[rand(max_idx)]
        param = DomainCache::DomainParameter.new("abcde." + domain_name)
        node = tld_node.node_search(param)
#        result_name = node.generate_domain_name
#        if result_name != domain_name then
#          print("Error Domain Name:", domain_name, "\n")
#          print("Error Result Name:", result_name, "\n")
#        end
#        assert(node.generate_domain_name == domain_name, "CASE:3-1")
      end
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
    end
    process_time = Time.now - start_time
    print("Node Search time:", process_time, " second\n")
  end
  
  # ツリーノードクラステスト：ドメイン検索
  test "3-1:Performance Test:Constructor" do
#    flunk("CASE:3-1 No Execute")
    ###########################################################################
    # ランダムなドメイン名を生成し、テストデータとしてドメインテーブルに登録
    ###########################################################################
    size = 1000
    max_depth = 6
    domain_name_list = Array.new
    while domain_name_list.size < size do
      domain_name_list.push(create_domain_name(max_depth))
    end
    uniq_list = domain_name_list.uniq
    print_log("Domain Name List Size     :" + domain_name_list.size.to_s)
    print_log("Domain Name List Uniq Size:" + uniq_list.size.to_s)
#    print_log("Insert Processing Start")
    start_time = Time.now
    create_domain(uniq_list, Domain::DOMAIN_CLASS_FIXED)
    process_time = Time.now - start_time
    print_log("Insert Processing time:" + process_time.to_s + " second")
    ###########################################################################
    # データのロード時間を測る
    ###########################################################################
    start_time = Time.now
    DomainCache.instance.data_load
    process_time = Time.now - start_time
    print_log("Load   Processing time:" + process_time.to_s + " second")
    ###########################################################################
    # ドメインを検索して、ドメインがメモリ上に展開されている事を確認
    ###########################################################################
    start_time = Time.now
    size = uniq_list.size
    max_idx = size - 1
    info = nil
    domain_name = nil
    size.times do
      domain_name = uniq_list[rand(max_idx)]
      id = DomainCache.instance.get_domain_id(domain_name)
      info = Domain.find(id)
      assert(info.domain_name == domain_name, "CASE:3-1-1-1")
    end
    process_time = Time.now - start_time
    print_log("Search Processing time:" + process_time.to_s + " second")
    ###########################################################################
    # トライアル
    ###########################################################################
    start_time = Time.now
    1000.times do
#      assert(info.domain_name == domain_name, "CASE:3-1-1")
      assert(info[:domain_name] == domain_name, "CASE:3-1-1-2")
#      assert(info['domain_name'] == domain_name, "CASE:3-1-1")
    end
    process_time = Time.now - start_time
    print_log("Trial Processing time:" + process_time.to_s + " second")
    ###########################################################################
    # 項目値アクセストライアル：パターン１
    ###########################################################################
    start_time = Time.now
    1000.times do
      values = Array.new
      values.push(info.domain_name) unless info.domain_name.nil?
      values.push(info.domain_class) unless info.domain_class.nil?
      values.push(info.date_confirmed) unless info.date_confirmed.nil?
      values.push(info.remarks) unless info.remarks.nil?
      values.push(info.delete_flg) unless info.delete_flg
    end
    process_time = Time.now - start_time
    print_log("Data Access Trial 1 Processing time:" + process_time.to_s + " second")
    ###########################################################################
    # 項目値アクセストライアル：パターン１
    ###########################################################################
    items = [:domain_name, :domain_class, :date_confirmed]
    start_time = Time.now
    1000.times do
      values = Array.new
      items.each do |item|
        values.push(info[item]) 
      end
    end
    process_time = Time.now - start_time
    print_log("Data Access Trial 2 Processing time:" + process_time.to_s + " second")
    ###########################################################################
    # 登録データの削除
    ###########################################################################
    start_time = Time.now
    delete_domain(uniq_list)
    process_time = Time.now - start_time
    print_log("Delete Processing time:" + process_time.to_s + " second")
    ###########################################################################
    # 存在しないホスト名での検索
    ###########################################################################
    id = DomainCache.instance.get_domain_id(nil)
    assert(id.nil?, "CASE:3-1-2")
    id = DomainCache.instance.get_domain_id('hoge.hoge.hoge.pt')
    assert(id.nil?, "CASE:3-1-2")
    id = DomainCache.instance.get_domain_id(100)
    assert(id.nil?, "CASE:3-1-2")
    ###########################################################################
    # データリロードテスト
    ###########################################################################
    # データリロード
    begin
      cache = DomainCache.instance
      start_time = cache.loaded_at
      sleep(1)
      cache.data_load
      assert(!cache.get_domain_id('ne.jp').nil?, "CASE:2-8-1-1")
      assert(!cache.get_domain_id('co.jp').nil?, "CASE:2-8-1-2")
      assert(!cache.get_domain_id('mixi.jp').nil?, "CASE:2-8-1-3")
      assert(!cache.get_domain_id('test.jp').nil?, "CASE:2-8-1-4")
      assert(cache.get_domain_id('not.found.co.jump').nil?, "CASE:2-8-1-5")
      assert(cache.loaded_at > start_time, "CASE:2-8-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
    # データリロード（0件）
    begin
      Domain.delete_all
      cache = DomainCache.instance
      start_time = cache.loaded_at
      sleep(1)
      cache.data_load
      assert(cache.loaded_at > start_time, "CASE:2-8-2, 2-8-3")
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
      raise ex
    end
  end
  
  # ドメイン名生成
  def create_domain_name(max_depth)
    domain_name = 'jp'
    (rand(max_depth - 3) + 2).times do
      domain_name = generate_str(CHAR_SET_ALPHABETIC, rand(7) + 3).downcase + '.' + domain_name
    end
    return domain_name
  end
  
  # ドメインツリー作成
  def create_tree(domain_name_list)
    # ツリーデータの生成
    tld_node = nil
    begin
      # TLDを生成
      info = Domain.new
      info.domain_name = domain_name_list[0]
      info.domain_class = Domain::DOMAIN_CLASS_FIXED
      info.date_confirmed = nil
      param = DomainCache::DomainParameter.new(info)
      tld_node = DomainCache::DomainTreeNode.new(param)
      result_node = tld_node.add_node(param)
#      result_name = result_node.generate_domain_name
#      if result_name != info.domain_name then
#        print("1.Error Domain Name:", domain_name, "\n")
#        print("1.Error Result Name:", result_name, "\n")
#      end
      # 残りをロード
      max = domain_name_list.size - 1
      for i in 1..max do
        info.domain_name = domain_name_list[i]
        param = DomainCache::DomainParameter.new(info)
        result_node = tld_node.add_node(param)
#        result_name = result_node.generate_domain_name
#        if result_name != info.domain_name then
#          print("2.Error Domain Name:", domain_name, "\n")
#          print("2.Error Result Name:", result_name, "\n")
#        end
      end
    rescue => ex
      print("Exception:", ex.class.name, "\n")
      print("Message  :", ex.message, "\n")
    end
    return tld_node
  end
  
  # ドメインの登録
  def create_domain(domain_name_list, domain_class)
    max = domain_name_list.size - 1
    time = Time.now
    for i in 0..max do
#      info = Domain.new({:domain_name => domain_name_list[i],
#                             :domain_class => domain_class,
#                             :date_confirmed => time})
      info = Domain.new
      info.domain_name = domain_name_list[i]
      info.domain_class = domain_class
      if domain_class != Domain::DOMAIN_CLASS_FIXED then
        info.date_confirmed = time
      end
      info.save!
    end
  end
  
  # ドメインの削除
  def destroy_domain(domain_name_list)
    max = domain_name_list.size - 1
    for i in 0..max do
      Domain.where(:domain_name => domain_name_list[i]).destroy_all
    end
  end
  
  # ドメインの削除
  def delete_domain(domain_name_list)
    max = domain_name_list.size - 1
    for i in 0..max do
      Domain.where(:domain_name => domain_name_list[i]).delete_all
    end
  end
end
