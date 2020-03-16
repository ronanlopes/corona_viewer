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
    []
  end

  def data
    objects.map do |tweet|
      Tweet::VIEW_COLUMNS.map{|c|
        if c==:user
          tweet["user"]["name"]
        elsif c==:place
          tweet.dig(:place, :full_name)
        else
          tweet[c]
        end
      }
    end
  end


  def fetch_objects
=begin    tweets = Tweet.order("#{sort_column} #{sort_direction}")

    if params[:search][:value].present?
      conditions = []

      conditions << "(CAST(tweets.id AS TEXT) LIKE ?)"


      values = []
      values <<  params[:search][:value]

      0.times do
        values << "%" + params[:search][:value] + "%"
      end

      conditions = ["(#{conditions.join(" or ")})"] + values
    end
=end


    MongoHelper.load_collection("tweets_coronavirus", page, per_page)
  end

end

