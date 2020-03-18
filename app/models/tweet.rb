class Tweet

	VIEW_COLUMNS = {
		:id => "id",
		:text => "text",
		:timestamp_ms => "timestamp_ms",
		:user => "user.screen_name",
		:followers_count => "user.followers_count",
		:friends_count => "user.friends_count",
		:verified => "user.verified",
		:source => "source",
		:place => "place.full_name"
	}

end
