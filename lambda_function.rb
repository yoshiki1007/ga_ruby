require 'net/https'
require 'json'
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

# data.rows.each do |row|
#   p row
# end

result = data.rows

uri = URI.parse("#{ENV['SLACK_WEB_HOOK_URL']}")

request = Net::HTTP::Post.new(uri.request_uri)
request.body = {text: "処理結果: #{result}"}.to_json

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

http.start do |h|
  puts h.request(request).body
end