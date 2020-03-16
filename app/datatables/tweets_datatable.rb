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
    Tweet::VIEW_COLUMNS
  end

  def data
    objects.map do |tweet|
      Tweet::VIEW_COLUMNS.map{|c|
        if c==:user
          tweet["user"]["name"]
        elsif c==:place
          tweet.dig(:place, :full_name)
        elsif c==:timestamp_ms
           I18n.l(Time.at(tweet["timestamp_ms"].to_i/1000).to_datetime)
        else
          tweet[c]
        end
      }
    end
  end


  def fetch_objects
    MongoHelper.load_collection("tweets_coronavirus", page.to_i-1, per_page, sort_column, sort_direction,params[:search][:value])
  end

end

