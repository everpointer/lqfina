class ApplicationController < ActionController::Base
  protect_from_forgery

  # constants
  # regular expressions
  REX_STAT_DATE = /\d{4}-(((0[1-9])|(1[0-2])))/

  # strings
  STAT_DATE_FORMAT = "%Y-%m"

  # integers
  STAT_DATE_FORMAT_LENGTH = 7

  def parse_stat_date_string(stat_date)
    if stat_date =~ REX_STAT_DATE
      @current_year_month = stat_date.slice(0, STAT_DATE_FORMAT_LENGTH)
    else
      @current_year_month = DateTime.now.strftime(STAT_DATE_FORMAT)
    end
  end

  def parse_stat_date(stat_date)
    str_stat_date =  parse_stat_date_string(stat_date)
    Date.parse(str_stat_date + "-01")
  end

end
