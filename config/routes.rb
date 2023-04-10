Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope "/religious_figures", defaults: { section: "religious_figures" } do
    get "/", to: "religious_figures#index", as: :religious_figures_home
    get "/new", to: "religious_figures#new", as: :religious_figures_new
    put "/new", to: "religious_figures#create", as: :religious_figures_create
    get "/item/:id/edit", to: "religious_figures#edit", as: :religious_figures_edit
    put "/item/:id/update", to: "religious_figures#update", as: :religious_figures_update
    Orchid::Routing.draw(section: "religious_figures", scope: "/religious_figures", routes: ["browse", "browse_facet", "item", "search"])
  end
  scope "/monasteries", defaults: { section: "monasteries" } do
    get "/", to: "monasteries#index", as: :monasteries_home
    get "/new", to: "monasteries#new", as: :monasteries_new
    put "/new", to: "monasteries#create", as: :monasteries_create
    get "/item/:id/edit", to: "monasteries#edit", as: :monasteries_edit
    put "/item/:id/update", to: "monasteries#update", as: :monasteries_update
    Orchid::Routing.draw(section: "monasteries", scope: "/monasteries", routes: ["browse", "browse_facet", "item", "search"])
  end
end
