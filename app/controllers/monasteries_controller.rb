class MonasteriesController < ItemsController
  
  require "rest-client"
  include DateHelper
  include ApplicationHelper

  def index
    # optional settings
    if params["f"].present? && params["q"].present?
      @title = "#{t "monasteries.search_results"}: \"#{params["q"]}\" - #{display_filters(params)}"
    elsif params["q"].present?
      @title = "#{t "monasteries.search_results"}: \"#{params["q"]}\""
    elsif params["f"].present?
      @title = "#{t "monasteries.search_results"}: #{display_filters(params)}"
    else
      @title = t "monasteries.title"
    end

    # query to return only cases
    options = params.permit!.deep_dup
    if options["f"]
      options["f"] << "category|Monasteries"
    else
      options["f"] = ["category|Monasteries"]
    end
    @res = @items_api.query(options)
    # render search preset with route information
    @route_path = "home_path"
    @facet_limit = @section.present? ? SECTIONS[@section]["api_options"]["facet_limit"] : PUBLIC["api_options"]["facet_limit"]
    render_overridable  "items", "search_preset", false, res: @res
  end

  def display_filters(params)
    if params["f"]
      params["f"].map { |filter| filter.split("|")[1]}.join(" / ")
    end
  end

end