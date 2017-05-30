class FaqsController < ApplicationController
  def index
    @faqs = Faq.all.order(position: :asc, id: :desc)
  end
end
