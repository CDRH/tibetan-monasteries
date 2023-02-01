module ItemsHelper
  include Orchid::ItemsHelper

  def search_item_link(item)
    category = item["category"].downcase
    item_id = item["identifier"]
    path = "#"
    title_display = item["title"].present? ?
      item["title"] : t("search.results.item.no_title", default: "Untitled")
    # redirect to correct path depending on category
    # so that [category]/items/_show_metadata will be displayed accordingly
    if category == "religious figures"
      path = religious_figures_item_path(id: item_id)
    elsif category == "monasteries"
      path = monasteries_item_path(id: item_id)
    end

    link_to title_display, path
  end
end