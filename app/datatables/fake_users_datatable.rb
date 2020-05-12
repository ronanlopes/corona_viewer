class FakeUsersDatatable < TemplateDatatable


  VIEW_COLUMNS = {
    :verify_score => "user.verify_score",
    :screen_name => "user.screen_name",
    :name => "user.name",
    :followers_count => "user.followers_count",
    :friends_count => "user.friends_count",
    :statuses_count => "user.statuses_count",
    :listed_count => "user.listed_count",
    :source => "source",
    :default_profile => "user.default_profile"
  }

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: objects.size,
      iTotalDisplayRecords: MongoHelper::CLIENT[:tweets_coronavirus].find().aggregate([{"$match":  {"user.verify_score": {"$lte": 2}} }, {'$group'=> {'_id'=> '$user.id'}} ]).count(),
      aaData: data
    }
  end


private

  def sort_columns_collection
    VIEW_COLUMNS.keys
  end

  def data

    objs = objects
    objs.map{|o|
      o[VIEW_COLUMNS.keys.index(:screen_name)] = link_to("@#{o[VIEW_COLUMNS.keys.index(:screen_name)]}", "https://www.twitter.com/#{o[VIEW_COLUMNS.keys.index(:screen_name)]}", target:"_blank").html_safe
    }
    objs

  end


  def fetch_objects
    MongoHelper.get_fake_users(page.to_i-1, per_page, VIEW_COLUMNS[sort_column], sort_direction,params[:search][:value])
  end

end

