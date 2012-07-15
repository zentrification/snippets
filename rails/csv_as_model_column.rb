class Article < ActiveRecord::Base
  require 'csv'

  module CSVSerializer
    module_function
    def load(field) field.to_s.parse_csv end
    def dump(object) Array(object).to_csv end
  end

  serialize :categories, CSVSerializer
end
