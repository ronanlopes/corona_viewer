class MongoHelper

	require 'mongo'

	Mongo::Logger.logger.level = ::Logger::FATAL
	CLIENT = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'puc-tcc')


	def self.load_collection(collection, offset, limit)
		CLIENT[collection].find.skip(offset).limit(limit).to_a
	end

end