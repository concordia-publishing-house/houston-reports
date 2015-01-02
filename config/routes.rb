Houston::Reports::Engine.routes.draw do
  
  get "by_user/:id", to: "reports#user_report"
  
end
