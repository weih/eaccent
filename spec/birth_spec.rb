require 'spec_helper'

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
