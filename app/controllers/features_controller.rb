class FeaturesController < ApplicationController


	def heat_map
		@points = MongoHelper.load_map_points
		render "heat_map"
	end


end