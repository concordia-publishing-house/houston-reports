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

    # Sprint and Alerts details for each week
    get "weekly", to: "reports#weekly_report", as: :weekly_report

    constraints bin: /weekly|daily/ do
      get ":bin/star/by_component.xlsx", to: "reports#star_export_by_component"
      get ":bin/star/chargeable.xlsx", to: "reports#star_export_chargeable"
    end
  end

end
