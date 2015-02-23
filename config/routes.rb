Houston::Reports::Engine.routes.draw do
  
  get "star", to: "reports#star"
  get "by_user/:nickname", to: "reports#user_report"
  get "by_user/:nickname/star.xlsx", to: "reports#user_star_report"
  
end
