require 'test_helper'

class GrantTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Grant.new.valid?
  end
end
