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

uri = URI.parse("#{ENV['SLACK_WEB_HOOK_URL']}")
request = Net::HTTP::Post.new(uri.request_uri)

request.body = {
	"blocks": [
		{
			"type": "header",
			"text": {
				"type": "plain_text",
				"text": "先週のPV数🦄",
				"emoji": true
			}
		},
		{
			"type": "section",
			"text": {
				"type": "plain_text",
				"text": "#{data.rows[7][0]} [PV] #{data.rows[7][1]}",
				"emoji": true
			}
		},
    {
			"type": "section",
			"text": {
				"type": "plain_text",
				"text": "#{data.rows[6][0]} [PV] #{data.rows[6][1]}",
				"emoji": true
			}
		},
    {
			"type": "section",
			"text": {
				"type": "plain_text",
				"text": "#{data.rows[5][0]} [PV] #{data.rows[5][1]}",
				"emoji": true
			}
		},
    {
			"type": "section",
			"text": {
				"type": "plain_text",
				"text": "#{data.rows[4][0]} [PV] #{data.rows[4][1]}",
				"emoji": true
			}
		},
    {
			"type": "section",
			"text": {
				"type": "plain_text",
				"text": "#{data.rows[3][0]} [PV] #{data.rows[3][1]}",
				"emoji": true
			}
		},
    {
			"type": "section",
			"text": {
				"type": "plain_text",
				"text": "#{data.rows[2][0]} [PV] #{data.rows[2][1]}",
				"emoji": true
			}
		},
    {
			"type": "section",
			"text": {
				"type": "plain_text",
				"text": "#{data.rows[1][0]} [PV] #{data.rows[1][1]}",
				"emoji": true
			}
		},
		{
			"type": "context",
			"elements": [
				{
					"type": "image",
					"image_url": "https://pbs.twimg.com/profile_images/625633822235693056/lNGUneLX_400x400.jpg",
					"alt_text": "cute cat"
				},
				{
					"type": "mrkdwn",
					"text": "今週も頑張ろう!"
				}
			]
		},
		{
			"type": "divider"
		}
	]
}.to_json

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

http.start do |h|
  puts h.request(request).body
end
