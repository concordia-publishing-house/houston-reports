module Houston::Reports
  class ReportsController < ApplicationController
    layout "email"
    
    helper Houston::Reports::ApplicationHelper
    
    helper_method :stylesheets
    class_attribute :stylesheets
    self.stylesheets = %w{
      core/colors.scss.erb
      application/emoji.scss
      application/scores.scss
    }
    
    self.stylesheets = stylesheets + %w{houston/reports/charts.scss}
    
    def user_report
      date = Date.parse(params[:date]) rescue Date.today
      user = User.find params[:id]
      @report = WeeklyUserReport.new(user, date)
    end
    
    def star
      template = params[:numbers] == "true" ? "houston/reports/reports/star_numbers" : "houston/reports/reports/star"
      @date_range = (Date.today - 14)..Date.today
      @measurements = Measurement \
        .named("daily.hours.{charged,worked,off}")
        .taken_on(@date_range)
        .includes(:subject)
      render template: template, layout: "dashboard"
    end
    
  end
end
