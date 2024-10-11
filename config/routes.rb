Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope "/religious_figures", defaults: { section: "religious_figures" } do
    get "/", to: "religious_figures#index", as: :religious_figures_home
    Orchid::Routing.draw(section: "religious_figures", scope: "/religious_figures", routes: ["browse", "browse_facet", "item", "search"])
  end
  scope "/monasteries", defaults: { section: "monasteries" } do
    get "/", to: "monasteries#index", as: :monasteries_home
    Orchid::Routing.draw(section: "monasteries", scope: "/monasteries", routes: ["browse", "browse_facet", "item", "search"])
  end
end
