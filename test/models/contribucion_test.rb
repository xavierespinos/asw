require 'test_helper'

class ContribucionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "order should be most recent first" do
    assert_equal contribucions(:most_recent), Contribucion.first
  end
  
end
