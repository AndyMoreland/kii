# encoding: utf-8
require 'test_helper'

class StringTest < ActiveSupport::TestCase
  test "to_permalink" do
    assert_equal "Øystein_Sunde_&_Bananene", "Øystein Sunde & Bananene".to_permalink
  end
  
  test "from_permalink" do
    assert_equal "Øystein Sunde & Bananene", "Øystein_Sunde_&_Bananene".from_permalink
  end
end
