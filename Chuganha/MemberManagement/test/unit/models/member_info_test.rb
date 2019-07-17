require 'test_helper'

class MemberInfoTest < ActiveSupport::TestCase
  test "member info validate" do
    instance = MemberInfo.new
    assert_blank instance
  end
  
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
