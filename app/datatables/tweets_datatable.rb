class TweetsDatatable < TemplateDatatable


  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: objects.size,
      iTotalDisplayRecords: MongoHelper::CLIENT["tweets_coronavirus"].find().count(),
      aaData: data
    }
  end


private

  def sort_columns_collection
    Tweet::VIEW_COLUMNS.keys
  end

  def data
    objects.map do |tweet|
      Tweet::VIEW_COLUMNS.keys.map{|c|
        if c==:user
          link_to("@#{tweet["user"]["screen_name"]}", "https://www.twitter.com/#{tweet["user"]["screen_name"]}", target:"_blank").html_safe
        elsif c==:timestamp_ms
           I18n.l(Time.at(tweet["timestamp_ms"].to_i/1000).to_datetime)
        elsif c==:id
          link_to(tweet["id"].to_s, "https://www.twitter.com/#{tweet["user"]["screen_name"]}/status/#{tweet["id"]}", target:"_blank").html_safe
        elsif Tweet::VIEW_COLUMNS[c].include?('.')
          parent, son = Tweet::VIEW_COLUMNS[c].split(".")
          tweet.dig(parent,son)
        else
          tweet[c]
        end
      }
    end
  end


  def fetch_objects
    MongoHelper.load_collection("tweets_coronavirus", page.to_i-1, per_page, Tweet::VIEW_COLUMNS[sort_column], sort_direction,params[:search][:value])
  end

end

