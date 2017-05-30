# frozen_string_literal: true
class ApplicationPresenter < Oprah::Presenter
  def source
    __getobj__
  end
end
