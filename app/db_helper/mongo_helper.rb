class MongoHelper

	require 'mongo'

	Mongo::Logger.logger.level = ::Logger::FATAL
	CLIENT = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'puc-tcc')

	def self.load_collection(collection, offset, limit, sort_column, sort_direction, search)
		#CLIENT[collection].find.sort({sort_column => (sort_direction == "asc" ? 1 : -1 )}).skip(offset).limit(limit).to_a
		collection = CLIENT[collection].find.to_a.sort_by{|t|
			if sort_column==:user
			 	coluna = t.dig(:user, :name).to_s
			elsif sort_column==:place
				coluna = t.dig(:place, :full_name).to_s
			else
				coluna = t[sort_column].to_s
			end
			coluna.upcase
		}
		collection = collection.reverse if sort_direction=="desc"

		collection = collection.select{|c| c["id"].to_s.upcase.include?(search.upcase) || c["text"].upcase.include?(search.upcase) || c["user"]["name"].upcase.include?(search.upcase) || c.dig(:place,:full_name).to_s.upcase.include?(search.upcase)} if search.present?

		collection[(offset*limit)..(((offset*limit)+limit)-1)]
	end


end