Houston::Reports::Engine.routes.draw do

  scope "reports" do
    # Shows who has entered their Star and Empower time over the last two weeks
    get "star/dashboard", to: "reports#star"

    # Modified Sprint dashboard that shows GoalKeeper goal progress as well
    get "sprint/dashboard", to: "reports#sprint"
    get "sprint/:id/dashboard", to: "reports#sprint"

    # Alerts, historical
    get "alerts", to: "alerts#index"

    # Scorecards
    get "weekly/by_user/:nickname", to: "reports#user_report"

    # Special Star report download (to remove)
    get "weekly/by_user/:nickname/star.xlsx", to: "reports#user_star_report"

    # Sprint and Alerts details for each week
    get "weekly", to: "reports#weekly_report", as: :weekly_report
  end

end
