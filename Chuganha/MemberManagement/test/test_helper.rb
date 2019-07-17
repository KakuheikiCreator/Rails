ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'objspace'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  # メモリ使用量取得
  def memsize(klass=false)
    total = 0
#    total += ObjectSpace.memsize_of_all(klass)
    size_hash = Hash.new
    ObjectSpace.each_object(klass) do |obj|
      msize = ObjectSpace.memsize_of(obj)
      total += msize
      size_hash[obj.class.to_s] = 0 if size_hash[obj.class.to_s].nil?
      size_hash[obj.class.to_s] += msize
    end
    if klass == false then
      size_hash.each_pair do |key, value|
        print_log(key + ':' + value.to_s)
      end
    end
    return total
  end
end
