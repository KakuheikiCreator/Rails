# -*- coding: utf-8 -*-
###############################################################################
# クラス：アプリケーションヘルパー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/01/31 Nakanohito
# 更新日:
###############################################################################
require 'common/session_util_module'

module ApplicationHelper
  # 著作権表記
  def copyright_notation(color="#ffffff")
    strong = content_tag(:strong, 'Copyright (C) 2011 仲観派 All Rights Reserved.')
    return content_tag(:font, strong, {:color=>color, :size=>"2"})
  end
  
  # 国際化キャッシュ
  def i18n_cache(param=nil, &block)
    return cache(&block) if param.nil?
    prefix = I18n.locale.to_s + "." + controller_path + "."
    return cache(prefix + param, &block) if String === param
    if Hash === param then
      return cache(prefix + param[:suffix].to_s, &block)
    end
  end
  
  # 国際化テキスト生成
  def vt(key, opts=nil)
    return "" unless String === key
    return I18n.t('views.' + controller_name + '.' + key, opts)
  end
  
  # エラーメッセージ
  def error_msg(msg)
    return "" if msg.nil? || msg == ""
    return content_tag(:div, msg, {:class=>'error_msg'})
  end
  
  # サーバー側エラーメッセージ
  def svr_error_tag(name, msg, opts={})
    return "" if msg.nil? || msg.empty?
    return hidden_field_tag(name, msg, opts)
  end
  
  # パラメータ付きフォームタグ
  def form_tag_with_params(url_options, options, transition_pattern, restored_transition_no=nil, &block)
    options[:method] = :post unless options.has_key?(:method)
    return form_tag(url_options, options) do
      transition_param_tag(transition_pattern, restored_transition_no) + capture(&block)
    end
  end
  
  # パラメータ付きフォームタグ（データモデルに紐付く）
  def form_for_with_params(ent, options, transition_pattern, restored_transition_no=nil, &block)
    html_opts = options[:html] 
    unless html_opts.nil? then
      html_opts[:method] = :post unless html_opts.has_key?(:method)
    end
    return form_for(ent, options) do |frm|
      transition_param_tag(transition_pattern, restored_transition_no) + capture(frm, &block)
    end
  end
  
  # 画面遷移パラメータのhiddenタグ
  def transition_param_tag(transition_pattern, restored_transition_no=nil)
    pattern = Common::SessionUtilModule.const_get(transition_pattern)
    state = session[:function_state]
    params_tag = hidden_field_tag('screen_transition_pattern', pattern) +
                 hidden_field_tag('function_transition_no', state.func_tran_no) +
                 hidden_field_tag('synchronous_token', state.sync_tkn)
    unless restored_transition_no.nil? then
      params_tag += hidden_field_tag('restored_transition_no', restored_transition_no)
    end
    return content_tag(:div, params_tag, {:style=>"margin:0;padding:0;display:inline"})
  end
  
  # リンク形式のサブミットタグ
  def link_submit_tag(opts={}, &block)
    opts[:onclick] = "submit_form('#" + opts[:id].to_s + "', '_self');return false;"
    return link_to(capture(&block), '', opts)
  end
  
  # モデル配列に対応したコンボボックスのメンバ
  def options_from_ents(ents, val_item, label_items, selected=nil, blank_msg=nil)
    return if ents.nil? || ents.size() == 0
    blank_tag = ""
    unless blank_msg.nil? then
      blank_msg = t("helpers.select.prompt") unless String === blank_msg
      blank_tag = content_tag(:option, blank_msg, {:value=>""})
    end
    unless (Array === label_items) then
      return raw(blank_tag) + options_from_collection_for_select(ents, val_item, label_items, selected)
    end
    # エンティティループ
    key_item = label_items.first
    key_label = ents.first[key_item]
    sub_label_items = label_items.last
    sub_label_items = label_items[1..label_items.size - 1] if (label_items.size > 2)
    sub_ents = Array.new
    tag_list = [blank_tag]
    ents.each do |ent|
      # キーブレーク判定
      if (key_label != ent[key_item]) then
        sub_content = options_from_ents(sub_ents, val_item, sub_label_items, selected)
        tag_list.push(content_tag(:optgroup, sub_content, {:label=>key_label}))
        key_label = ent[key_item]
        sub_ents = Array.new
      end
      sub_ents.push(ent)
    end
    sub_content = options_from_ents(sub_ents, val_item, sub_label_items, selected)
    tag_list.push(content_tag(:optgroup, sub_content, {:label=>key_label}))
    return raw(tag_list.join)
  end
  
  # コード選択コンボボックス
  def code_select_tag(name, code_id, selected={}, opts={})
    opts_tag = options_from_code(code_id, selected, opts.delete(:include_blank))
    return select_tag(name, raw(opts_tag), opts)
  end
  
  # コード選択コンボボックスオプション
  def options_from_code(code_id, selected={}, blank_msg=nil)
    label_hash = Hash.new
    unless (blank_msg.nil?) then
      blank_msg = t("helpers.select.prompt") unless String === blank_msg
      label_hash[blank_msg] = nil
    end
    code_info = DataCache::GenericCodeCache.instance.code_info(code_id)
    label_hash.update(code_info.labels_hash.dup) unless code_info.nil?
    opts_tag = options_for_select(label_hash, selected)
    return raw(opts_tag)
  end
  
  # コードラベル
  def code_label(code_id, value)
    code_info = DataCache::GenericCodeCache.instance.code_info(code_id)
    return code_info.code_hash[value]
  end
  
  # 日時フォーマット
  def default_time(time=Time.now)
    return '' if time.nil?
    time_format = I18n.t('time.formats.default')
    return time.strftime(time_format)
  end
  
  # 日時選択コンボボックス
  def default_select_datetime(value, name, opts={})
    opts[:prefix] = name.to_s
    opts[:use_month_numbers] = true
    opts[:date_separator]    = '/'
    opts[:time_separator]    = ':'
    opts[:include_seconds]   = true
    return select_datetime(value, opts)
  end
  
  # hidden項目
  def hidden_tag(name, value)
    id = name.to_s.gsub('[', '_').gsub(']', '')
    return content_tag(:div, hidden_field_tag(name, value), {:style=>"margin:0;padding:0;display:inline"})
  end
      
  # クリアボタン生成
  def clear_button(opts={})
    opts[:type] = "button"
    opts[:value] = t('helpers.button.clear')
    opts[:onclick] = "clear_form(this)"
    return tag("input", opts)
  end
end
