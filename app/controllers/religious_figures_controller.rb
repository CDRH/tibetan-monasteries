class ReligiousFiguresController < ItemsController
  def index
    # optional settings
    @title = t "religious_figures.title"

    # query to return only cases
    options = params.permit!.deep_dup
    options["f"] = ["category|Religious figures"]
    @res = @items_api.query(options)
    # render search preset with route information
    @route_path = "home_path"
    render_overridable "items", "search_preset"
  end
end