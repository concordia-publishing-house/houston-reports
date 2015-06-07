Houston::Reports::Engine.routes.draw do
  
  get "star", to: "reports#star"

  get "sprint/dashboard", to: "reports#sprint"
  get "sprint/:id/dashboard", to: "reports#sprint"

  get "weekly/by_user/:nickname", to: "reports#user_report"
  get "weekly/by_user/:nickname/star.xlsx", to: "reports#user_star_report"
end
