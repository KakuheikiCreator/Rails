# -*- coding: utf-8 -*-
###############################################################################
# メッセージ送信クラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/07 Nakanohito
# 更新日:
###############################################################################
require 'rubygems'
require 'rack'

class TestRack
  # 初期化メソッド
  def initialize(logger)
    @logger = logger
    logger.debug('Rack Logger Test OK!')
  end

  def call(env)
    @logger.debug('REQUEST_METHOD:' + env['REQUEST_METHOD'].class.name)
    Rails.logger.debug("ENV:" + env.class.name)
#    [200, {"Content-Type" => "text/plain"}, [env.to_s]]
#    [200, {"Content-Type" => "text/plain"}, ["Test Rack Response!!!"]]
    req = Rack::Request.new(env)
    Rails.logger.debug("Method:" + req.post?.to_s)
    Rails.logger.debug("prams:" + req.params.to_s)
    res = Rack::Response.new
    res.write req.env.map {|k,v|
      c = v.class.name
      "<li>#{k}: #{v}: #{c}:</li>"
    }.sort.join("\n")
#    res.write "<li>REMOTE_ADDR: " + req.env['REMOTE_ADDR'] + "</li>\n"
    return res.finish
  end
end
