# -*- encoding: utf-8 -*-
module ActionView
  module Helpers
    module FormTagHelper
      alias_method :original_submit_tag, :submit_tag
      def submit_tag(value=nil, options={})
        options[:data] = Hash.new if options[:data].nil?
        opt_data = options[:data]
        if opt_data[:disable_with].nil? then
          opt_data[:disable_with] = I18n.t('helpers.submit.sending')
        end
        original_submit_tag(value, options)
      end
    end
  end
end