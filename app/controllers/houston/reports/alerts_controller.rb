module Houston::Reports
  class AlertsController < ApplicationController
    layout "houston/reports/minimal"


    def index
      @title = "Alerts Report"
      @date_range = Date.new(2015, 1, 1)..Date.today

      # Align @date_range to weeks
      @date_range = @date_range.begin.beginning_of_week..(6.days.after(@date_range.end.beginning_of_week))

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

      @alerts_due_on_time_by_type = types.each_with_object({}) do |type, hash|
        _alerts = alerts.where(type: type)
          .where("deadline BETWEEN weeks.start AND (weeks.start + '1 week'::interval)")
        hash[type] = ActiveRecord::Base.connection.select_all <<-SQL
          SELECT
            ("weeks"."start" + '1 week'::interval) "week",
            (#{_alerts.to_sql}) "due",
            (#{_alerts.closed_on_time.to_sql}) "on_time"
          FROM generate_series('#{@date_range.begin}'::date, '#{@date_range.end}'::date, '1 week') AS weeks(start)
          ORDER BY weeks.start ASC
        SQL
      end
    end


  end
end
