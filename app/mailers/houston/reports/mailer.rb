module Houston::Reports
  class Mailer < ::ViewMailer
    self.stylesheets = stylesheets + %w{houston/reports/charts.scss}
    
    helper Houston::Reports::ApplicationHelper
    
    
    def weekly_user_report(report, options={})
      @report = report
      
      mail(options.pick(:cc, :bcc).merge({
        to:       options.fetch(:to, report.user),
        subject:  "#{report.username} ⭑ #{report.date.strftime("%b %-d, %Y")}",
        template: "houston/reports/reports/user_report"
      }))
    end
    
    
  end
end
