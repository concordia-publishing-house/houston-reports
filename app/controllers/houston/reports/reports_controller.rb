module Houston::Reports
  class ReportsController < ApplicationController
    layout "email"
    
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
    
  end
end
