module Houston::Reports
  class ReportsController < ApplicationController
    layout "email"
    
    helper Houston::Reports::ApplicationHelper
    
    helper_method :stylesheets
    class_attribute :stylesheets
    self.stylesheets = %w{
      core/colors.scss.erb
      core/scores.scss
      application/emoji.scss
    }
    
    self.stylesheets = stylesheets + %w{houston/reports/charts.scss}
    
    def user_report
      date = Date.parse(params[:date]) rescue Date.today
      user = User.find_by_nickname! params[:nickname]
      authorize! :edit, user
      @report = WeeklyUserReport.new(user, date)
    end
    
    def star
      date = Date.parse(params[:date]) rescue Date.today
      @report = WeeklyGoalReport.new(date)

      @date_range = (date - 14)..date
      @measurements = Measurement \
        .named("daily.hours.{charged,worked,off}")
        .taken_on(@date_range)
        .includes(:subject)
      render layout: request.xhr? ? false : "houston/reports/dashboard"
    end
    
    def sprint
      @title = "Sprint"
      @sprint = Sprint.find_by_id(params[:id]) || Sprint.current || Sprint.create!
      
      @report = WeeklyGoalReport.new(@sprint.start_date)
      
      respond_to do |format|
        format.json do
          render json: {
            start: @sprint.start_date,
            tasks: SprintTaskPresenter.new(@sprint).as_json,
            sprintGoalHtml: render_to_string(partial: "sprint_goal", formats: [:html]) }
        end
        format.html do
          render layout: "houston/reports/dashboard"
        end
      end
    end
    
    def user_star_report
      user = User.find_by_nickname! params[:nickname]
      authorize! :edit, user
      measurements = Measurement \
        .for(user)
        .named("daily.hours.charged.*")
        .taken_since(Date.new(2015, 1, 1))
      
      prefix = "daily.hours.charged."
      measurements_by_component = measurements.group_by { |measurement| measurement.name[prefix.length..-1] }
      measurements_by_component.delete "percent"
      dates = measurements.map(&:taken_on).uniq.reverse
      
      package = Xlsx::Package.new
      worksheet = package.workbook.worksheets[0]
      
      heading = {
        alignment: Xlsx::Elements::Alignment.new("left", "center") }
      general = {
        alignment: Xlsx::Elements::Alignment.new("left", "center") }
      timestamp = {
        format: Xlsx::Elements::NumberFormat::DATE,
        alignment: Xlsx::Elements::Alignment.new("right", "center") }
      number = {
        alignment: Xlsx::Elements::Alignment.new("right", "center") }
      
      worksheet.add_row(
        number: 2,
        cells: dates.each_with_index.map { |date, j|
          { column: j + 3, value: date, style: timestamp } } + [
          { column: dates.length + 3, value: "total", style: heading }
        ])
      
      last_column = column_letter(dates.length + 2)
      
      measurements_by_component.each_with_index do |(component, measurements), i|
        worksheet.add_row(
          number: i + 3,
          cells: [
            { column: 2, value: component, style: heading }
          ] + dates.each_with_index.map { |date, j|
            measurement = measurements.find { |measurement| measurement.taken_on? date }
            value = measurement && measurement.value.to_d
            { column: j + 3, value: value, style: number } } + [
            { column: dates.length + 3, formula: "SUM(C#{i + 3}:#{last_column}#{i + 3})", style: number },
            { column: dates.length + 4, value: component, style: heading }
          ])
      end
      
      worksheet.add_row(
        number: measurements_by_component.length + 3,
        cells: [
          { column: 2, value: "total", style: heading }
        ] + dates.each_with_index.map { |date, j|
          column = column_letter(j + 3)
          { column: j + 3, formula: "SUM(#{column}3:#{column}#{measurements_by_component.length + 2})", style: number } })
      
      
      worksheet.column_widths({1 => 3.83203125})
      
      send_data package.to_stream.string,
        type: :xlsx,
        filename: "Star Time for #{user.name}.xlsx",
        disposition: "attachment"
    end
    
  private
    
    def column_letter(number)
      bytes = []
      remaining = number
      while remaining > 0
        bytes.unshift (remaining - 1) % 26 + 65
        remaining = (remaining - 1) / 26
      end
      bytes.pack "c*"
    end
    
  end
end
