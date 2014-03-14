# require 'minitest/autorun'
# require 'minitest/spec'
require 'date'
require 'yaml'
require 'rspec/autorun'
require 'pry'

module Eaccent
  CONFIG_FILE = YAML.load_file('./config.yml')
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

describe Eaccent do
  before(:all) do
    @normal_date_obj = Date.parse('2014/03/07')
  end

  it 'should accept with big_endian' do
    big_endian_date = '2014.03.07'
    @big_endian_formatter = Eaccent::BirthFormatter.new(big_endian_date, Eaccent::BIG_ENDIAN)
    @big_endian_formatter.format_birth.should eq(@normal_date_obj)
  end

  it 'should accept with little_endian' do
    little_endian_date = '07/03/14'
    @little_endian_formatter = Eaccent::BirthFormatter.new(little_endian_date, Eaccent::LITTLE_ENDIAN)
    @little_endian_formatter.format_birth.should eq(@normal_date_obj)
  end

  it 'should accept with middle_endian' do
    middle_endian_date = '03-07-2014'
    @middle_endian_formatter = Eaccent::BirthFormatter.new(middle_endian_date, Eaccent::MIDDLE_ENDIAN)
    @middle_endian_formatter.format_birth.should eq(@normal_date_obj)
  end

  it 'should accept whitespace_splitted_date' do
    whitespace_splitted_date = '14 03 07'
    @middle_endian_formatter = Eaccent::BirthFormatter.new(whitespace_splitted_date, Eaccent::BIG_ENDIAN)
    @middle_endian_formatter.format_birth.should eq(@normal_date_obj)
  end

  it 'should raise a BadDateError when date is invalid' do
    invalid_date = '22/13/13'
    @bad_date_endian_formatter = Eaccent::BirthFormatter.new(invalid_date, Eaccent::BIG_ENDIAN)
    # invalid_date = lambda { @bad_date_endian_formatter.format_birth }
    # except invalid_date.to raise_error(Eaccent::BadDateError)
    lambda { @bad_date_endian_formatter.format_birth }.should raise_error(Eaccent::BadDateError)
  end
end
