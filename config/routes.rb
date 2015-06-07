Houston::Reports::Engine.routes.draw do

  get "star/dashboard", to: "reports#star"

  get "sprint/dashboard", to: "reports#sprint"
  get "sprint/:id/dashboard", to: "reports#sprint"

  get "weekly/by_user/:nickname", to: "reports#user_report"
  get "weekly/by_user/:nickname/star.xlsx", to: "reports#user_star_report"

  get "weekly", to: "reports#weekly_report", as: :weekly_report

end
