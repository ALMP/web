require "test_helper"

class FaqTest < ActiveSupport::TestCase
  def faq
    @faq ||= Faq.new
  end

  def test_valid
    assert faq.valid?
  end
end
