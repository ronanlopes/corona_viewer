class TwitterHelper

	CONSUMER_KEY = "IsMgD6C0aVRHSDHbcpgIj0R3U"
	CONSUMER_SECRET = "aIbzwN2QdwUPhvD2a1R62qNPKCqbGBOx5RJcYFNhXd9QCLAtkT"
	ACCESS_TOKEN = '855901890080636928-BXrg751gVrehvbLCZW2jUUHvxR9Xniv'
	ACCESS_TOKEN_SECRET = 'YIhWzmBhzGSZJ7lC46gUEYQRpjBdrdSWOZtRvf9atTINS'


	def self.request_token
		consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, {
			:site => "https://api.twitter.com",
			:scheme => :header
		})

		return consumer.get_request_token(:oauth_callback => CALLBACK_URL)
	end

	def self.client
		Twitter::REST::Client.new(
			:consumer_key => CONSUMER_KEY,
			:consumer_secret => CONSUMER_SECRET,
			:access_token => ACCESS_TOKEN,
			:access_token_secret => ACCESS_TOKEN_SECRET
		)
	end

	def self.search(term, lang="pt", result_type="popular", count=15)
		results = self.client.search(term, lang:lang, result_type: result_type, count: count)
		results.map{|t| {user_name: t[:user][:name], user_screen_name: t[:user][:screen_name], created_at: t[:created_at].to_datetime.strftime("%d/%m/%Y %H:%M"), text: t[:text], retweet_count: t[:retweet_count], favorite_count: t[:favorite_count], media_url: t.media.first.try(:media_url_https).try(:to_s), uri: "https://www.twitter.com/#{t.user.screen_name}/status/#{t.id}"}}
	end


	def self.get_timeline

		begin
			self.client.user_timeline(count: 10).map{|t|
				text = t.text.gsub("\n","<br>")
				uri = URI.extract(text)

				if uri.present? && t.media.present?
					text = text.gsub(uri.last,"").strip
				end

				{
					user_name: t.user.name, user_screen_name: t.user.screen_name, created_at: (t.created_at + Time.zone.utc_offset).strftime("%d/%m/%Y às %H:%M"),
					uri: t.uri.to_s, text: text, media_url: t.media.first.try(:media_url_https).try(:to_s),
					retweet_count: t.retweet_count, favorite_count: t.favorite_count
				}
			}
		rescue
			[]
		end

	end

	def self.get_user_data(user)
		begin
			self.client.user(user.to_s)
		rescue Exception => ex
			Rails.logger.debug 222222222222222222222222222222
			Rails.logger.debug ex.message
			{}
		end
	end


	def self.get_followers

		begin
			{ users:
				self.client.followers(count: 10).map{|u|
					{
						name: u.name,
						screen_name: u.screen_name,
						profile_img: u.profile_image_url_https.to_s.gsub("_normal",""),
						bg_img: u.profile_banner_url,
						bio: u.description
					}
				}
			}
		rescue Twitter::Error::TooManyRequests
			{error: "Limite de requisições excedido!"}
		end

	end



	def self.get_following

		begin
			{ users:
				self.client.following(count: 10).map{|u|
					{
						name: u.name,
						screen_name: u.screen_name,
						profile_img: u.profile_image_url_https.to_s.gsub("_normal",""),
						bg_img: u.profile_banner_url,
						bio: u.description
					}
				}
			}
		rescue Twitter::Error::TooManyRequests
			{error: "Limite de requisições excedido!"}
		end

	end


	def self.get_likes

		begin
			{ tweets:
				self.client.favorites(count: 10).map{|t|

					text = t.text.gsub("\n","<br>")
					uri = URI.extract(text)

					if uri.present? && t.media.present?
						text = text.gsub(uri.last,"").strip
					end

					{
						user_name: t.user.name, user_screen_name: t.user.screen_name, user_profile_img: t.user.profile_background_image_url_https.to_s.gsub("_normal",""),
						created_at: (t.created_at + Time.zone.utc_offset).strftime("%d/%m/%Y às %H:%M"),
						uri: t.uri.to_s, text: text, media_url: t.media.first.try(:media_url_https).try(:to_s),
						retweet_count: t.retweet_count, favorite_count: t.favorite_count
					}
				}
			}
		rescue Twitter::Error::TooManyRequests
			{error: "Limite de requisições excedido!"}
		end

	end




end