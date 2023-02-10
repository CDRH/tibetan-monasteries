class ReligiousFiguresController < ItemsController
  def index
    # optional settings
    @title = t "religious_figures.title"

    # query to return only cases
    options = params.permit!.deep_dup
    if options ["f"]
      options ["f"] << "category|Religious figures"
    else
      options["f"] = ["category|Religious figures"]
    end
    @res = @items_api.query(options)
    # render search preset with route information
    @route_path = "home_path"
    @facet_limit = @section.present? ? SECTIONS[@section]["api_options"]["facet_limit"] : PUBLIC["api_options"]["facet_limit"]
    render_overridable "items", "search_preset", locals: { res: @res}
  end
end