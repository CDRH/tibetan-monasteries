class ReligiousFiguresController < ItemsController
  
  require "rest-client"
  include DateHelper
  include ApplicationHelper

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
    render_overridable("items", "search_preset", false)
  end

  def edit
    id = params[:id]
    @res = @items_api.get_item_by_id(id)
    check_response
    @res = @res.first
    if @res
      url = @res["uri_html"]
      @html = Net::HTTP.get(URI.parse(url)) if url
      @title = item_title
      render "religious_figures/edit"
    else
      @title = t "item.no_item", id: id,
        default: "No item with identifier #{id} found!"
      render_overridable("items", "show_not_found", false, status: 404)
    end
  end

  def update
    json = JSON.parse(params[:figure])
    id = params[:id]
    json["description"] = params[:description]
    json["title"] = params[:title]
    json["date_display"] = params[:date_display]
    json["date_not_before"] = date_standardize(params[:date_not_before], false)
    json["date_not_after"] = date_standardize(params[:date_not_after], false)
    json["spatial"]["name"] = params[:spatial_name]
    json["relation"] = params[:relation]
    rdf = []
    idx = 0
    # loop through all the numbered keys
    while params.has_key?("name_#{idx}")
      figure = {"subject" => params[:title]}
      name = params["name_#{idx}"]
      fig_id = params["id_#{idx}"]
      figure["object"] = "[#{name}](#{fig_id})"
      figure["predicate"] = params["predicate_#{idx}"]
      figure["source"] = params["source_#{idx}"]
      figure["note"] = params["note_#{idx}"]
      rdf << figure
      idx += 1
    end
    json["rdf"] = rdf
    # below should be refactored into more general helper methods
    project_dir = File.join(File.dirname(__FILE__), "..", "..")
    # path to the gem's config files
    general_config_path = File.join(project_dir, "config")
    # at some point I also need to factor into environments, private.yml for passwords
    @options = read_config("#{general_config_path}/public.yml")
    auth_header = construct_auth_header(@options)
    index_url = File.join(@options["es_path"], @options["es_index"])
    RestClient.put("#{index_url}/_doc/#{id}", json.to_json, auth_header.merge({:content_type => :json }) )
    redirect_to religious_figures_item_path(id)
  end

  def new
    id = generate_id
    @res = {
      "title" => "",
      "date_not_before" => "",
      "date_not_after" => "",
      "spatial" => {
        "name" => ""
      },
      "description" => "",
      "relation" => "",
      "rdf" => []
    }
    render "religious_figures/new"
  end

  def create
  end

  private

  def generate_id
    #query api and determine nubmer of items
    options = {
      "f" => ["category|Religious Figures"]
    }
    @res = @items_api.query(options)
    count = @res.count
    "fig_#{count + 1}"
  end

end