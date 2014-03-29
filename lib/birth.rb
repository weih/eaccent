require 'date'
require 'yaml'
# require 'pry'

module Eaccent
  CONFIG_FILE = YAML.load_file('./config/config.yml')
  BIG_ENDIAN = CONFIG_FILE['date_format']['big_endian']
  LITTLE_ENDIAN = CONFIG_FILE['date_format']['little_endian']
  MIDDLE_ENDIAN = CONFIG_FILE['date_format']['middle_endian']
  SPLIT_REGEX = /\s+|-|\.|\//

  class BadDateError < StandardError
  end

  # This class should be a Model Validator class or something similar in Rails
  # Also, endian should be set when our Rails app is boot up
  class BirthFormatter
    def initialize(date, endian)
      @date = date
      @endian = endian
    end

    def format_birth
      extract_date
      check_date
      formatted_date = "#{@year}-#{@month}-#{@day}"
      Date.parse(formatted_date)
    end

    def extract_date
      splitted_date = @date.split(Eaccent::SPLIT_REGEX)
      @year = splitted_date[@endian['year']]
      format_year
      @month = splitted_date[@endian['month']]
      @day = splitted_date[@endian['day']]
    end

    def format_year
      if @year.size == 2
        @year = @year.to_i + 2000
      end

      @year.to_s
    end

    def check_date
      raise BadDateError if invalid_date?
    end

    def invalid_date?
      # binding.pry
      (@year.to_s.size != 4 && @year.to_s.size != 2) ||
      (@month.to_i < 1 || @month.to_i > 12) ||
      (@day.to_i < 1 || @day.to_i > 31)
    end
  end
end
