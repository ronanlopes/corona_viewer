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



    def self.create_indexes
        CLIENT[:tweets_coronavirus].indexes.create_one( { "text" => 1 }, "collation" => { "locale" => "pt" })
        CLIENT[:tweets_coronavirus].indexes.create_one( { "id" => 1 }, "collation" => { "locale" => "pt" })
        CLIENT[:tweets_coronavirus].indexes.create_one( { "timestamp_ms" => 1 }, "collation" => { "locale" => "pt" })
        CLIENT[:tweets_coronavirus].indexes.create_one( { "users.name" => 1 }, "collation" => { "locale" => "pt" })
        CLIENT[:tweets_coronavirus].indexes.create_one( { "place.full_name" => 1 }, "collation" => { "locale" => "pt" })
    end


end