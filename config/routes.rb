Houston::Reports::Engine.routes.draw do
  
  get "star", to: "reports#star"
  get "by_user/:id", to: "reports#user_report"
  
end
