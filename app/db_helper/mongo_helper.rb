class MongoHelper

    require 'mongo'

    Mongo::Logger.logger.level = ::Logger::FATAL
    CLIENT = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'puc-tcc')

    def self.load_collection(collection, offset, limit, sort_column, sort_direction, search)
        CLIENT[collection].find({ "$or": [{ text: /#{Regexp.quote(search)}/i}, {"user.name": /#{Regexp.quote(search)}/i}, { id: /#{Regexp.quote(search)}/i}, {"place.full_name": /#{Regexp.quote(search)}/i }] }).sort({sort_column => (sort_direction == "asc" ? 1 : -1 )}).skip(offset).limit(limit).to_a
    end


    def self.load_map_points

        CLIENT[:tweets_coronavirus].find({"place.bounding_box.coordinates":{"$exists":true}}).to_a.map{|t|
            coordenadas = t["place"]["bounding_box"]["coordinates"][0]
            n = coordenadas.size
            {
                user: t["user"]["screen_name"],
                user_name: t["user"]["name"],
                profile_pic: t["user"]["profile_image_url_https"],
                followers: t["user"]["followers_count"],
                coordinates: [coordenadas.sum{|d| d[0]}/n, coordenadas.sum{|d| d[1]}/n]
            }
        }.select{|p| p[:coordinates][1] > -33.69111 && p[:coordinates][1] < 2.81972 && p[:coordinates][0] > -72.89583 && p[:coordinates][0] < -34.80861}

    end


    def self.so_data

        so = {"android" => 0, "iphone" => 0, "web" => 0, "other" => 0}


        CLIENT[:tweets_coronavirus].find().aggregate([{ '$group'=> { '_id'=> '$source', 'count'=> { '$sum'=> 1 } } }]).to_a.map{|source|

            s = source["_id"].downcase

            if s.include?("android")
                so["android"]+=source["count"]
            elsif s.include?("iphone")
                so["iphone"]+=source["count"]
            elsif s.include?("web")
                so["web"]+=source["count"]
            else
                so["other"]+=source["count"]
            end

        }

        so

    end


    def self.word_cloud_data

        count={}
        tweets = CLIENT[:tweets_coronavirus].find().projection({text: 1}).to_a
        tweets.map{|tweet| tweet["text"].split.map{|w| count[w.upcase.mb_chars.to_s] = count[w.upcase.mb_chars.to_s].to_i + 1 if w.size > 4}}
        count.select{|k,v| v > 1000 && !k.include?("@")}.sort_by{|k,v| v}.reverse

=begin
        count=[]
        tweets = CLIENT[:tweets_coronavirus].find().aggregate([{ "$project": { "text": { "$split": ["$text", " "] } } },{ "$unwind": "$text" },{ "$group": { "_id":  "$text" , "total": { "$sum": 1 } } },{ "$sort": { "total": -1 } }]).to_a
        tweets.select{|t| t["total"] > 1000 && t["_id"].size > 4 && !t["_id"].include?("@")}.map{|t| count << [t["_id"],t["total"]] }
        count
=end

    end


    def self.get_usuarios_grau_de_entrada
        CLIENT[:tweets_coronavirus].find().sort({"user.followers_count" => -1}).limit(15).to_a.map{|t| t[:user]}.uniq[0..9]
    end

    def self.create_indexes
        CLIENT[:tweets_coronavirus].indexes.create_one( { "text" => 1 }, "collation" => { "locale" => "pt" })
        CLIENT[:tweets_coronavirus].indexes.create_one( { "id" => 1 }, "collation" => { "locale" => "pt" })
        CLIENT[:tweets_coronavirus].indexes.create_one( { "timestamp_ms" => 1 }, "collation" => { "locale" => "pt" })
        CLIENT[:tweets_coronavirus].indexes.create_one( { "users.name" => 1 }, "collation" => { "locale" => "pt" })
        CLIENT[:tweets_coronavirus].indexes.create_one( { "users.screen_name" => 1 }, "collation" => { "locale" => "pt" })
        CLIENT[:tweets_coronavirus].indexes.create_one( { "users.followers_count" => 1 }, "collation" => { "locale" => "pt" })
        CLIENT[:tweets_coronavirus].indexes.create_one( { "place.full_name" => 1 }, "collation" => { "locale" => "pt" })
    end


end