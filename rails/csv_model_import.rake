# To import your CSV file:
# rake csv_model_import[bunnies.csv,Bunny]
#
# Note that your CSV needs to have a header line with the attribute names:
#
# http://erikonrails.snowedin.net/?p=212
# ------------------------------
desc "Import a CSV file into an ActiveRecord table: rake csv_model_import[data.csv,ModelName]"
task :csv_model_import, [:filename, :model] => :environment do |task,args|
  lines = File.new(args[:filename]).readlines
  header = lines.shift.strip
  keys = header.split(',').map &:downcase
  lines.each do |line|
    params = {}
    values = line.strip.split(',')
    keys.each_with_index do |key,i|
      params[key] = values[i]
    end
    Module.const_get(args[:model]).create(params)
  end
end
