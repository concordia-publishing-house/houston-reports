module Houston::Reports
  class AlertsController < ApplicationController
    layout "houston/reports/minimal"


    def index
      @date_range = Date.new(2015, 1, 1)..Date.today

      @project_id = params.fetch(:project_id, "-1") # -1 is all projects
      @user_id = params.fetch(:user_id, "-1") # -1 is everyone

      @projects = Project.where(Project.arel_table[:id].in(
        Houston::Alerts::Alert.select(:project_id).arel))
      @users = User.where(User.arel_table[:id].in(
        Houston::Alerts::Alert.select(:checked_out_by_id).arel))

      alerts = Houston::Alerts::Alert.reorder(nil).select("COUNT(*)")
      alerts = alerts.where(project_id: @project_id) unless @project_id == "-1"
      alerts = alerts.where(checked_out_by_id: @user_id) unless @user_id == "-1"

      types = alerts.pluck("DISTINCT type")

      @alerts_opened_closed_by_type = types.each_with_object({}) do |type, hash|
        _alerts = alerts.where(type: type)
        hash[type] = ActiveRecord::Base.connection.select_all <<-SQL
          SELECT
            "days"."day",
            (#{_alerts.where("opened_at::date = days.day").to_sql}) "alerts_opened",
            (#{_alerts.where("closed_at::date = days.day").to_sql}) "alerts_closed"
          FROM generate_series('#{@date_range.begin}'::date, '#{@date_range.end}'::date, '1 day') AS days(day)
          ORDER BY days.day ASC
        SQL
      end
    end


  end
end
