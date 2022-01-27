require 'dotenv/load'
require 'google/apis/analytics_v3'

client = Google::Apis::AnalyticsV3::AnalyticsService.new
client.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: File.open('./key_file.json'),
  scope: ENV['SCOPE']
)

data = client.get_ga_data(
  "ga:#{ENV['VIEW_ID']}",
  (Date.today - 7).strftime,
  Date.today.strftime,
  "ga:pageviews",
  {
    dimensions: 'ga:date',
    sort: "-ga:date"
  }
)

data.rows.each do |row|
  p row
end
