require 'test_helper'

class WorktypeTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Worktype.new.valid?
  end
end
