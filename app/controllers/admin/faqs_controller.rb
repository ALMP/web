require 'administrate/ransack_search'

module Admin
  class FaqsController < Admin::ApplicationController

    def index
      page = Administrate::Page::Collection.new(dashboard, order: order)      
      render locals: {
        resources: resources,
        search_term: search_term,
        page: page,
        q: search.q
      }
    end

    def update
      query = 'UPDATE "faqs" SET "position" = (CASE "id" '
      ids = ''
      params['faq'].each_with_index do |e, i|
        query += "WHEN #{e} THEN #{i}\n"
        ids += "#{e},"
      end
      query += "END) WHERE \"id\" IN (#{ids[0..-2]});"
      ActiveRecord::Base.connection.exec_query(query)
      redirect_to admin_faqs_path
    end

    def search
      @_search ||= Administrate::RansackSearch.new(resource_resolver, params[:q])
    end

    def resources
      params[:q] ||= { "s"=>["position asc","id desc"] }
      resource_class
        .ransack(params[:q])
        .result
    end
  end
end
