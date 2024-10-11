class MonasteriesController < ItemsController
  
  require "rest-client"
  include DateHelper
  include ApplicationHelper

  def index
    # optional settings
    @title = t "monasteries.title"

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

end