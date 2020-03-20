class FeaturesController < ApplicationController


    def heat_map
        @points = MongoHelper.load_map_points
        render "heat_map"
    end


    def word_cloud
    end


    def get_cloud_path
        words = MongoHelper.word_cloud_data[0..100]
        cloud = MagicCloud::Cloud.new(words, rotate: :free, scale: :log)
        img = cloud.draw(1200, 800) #default height/width
        img_path = "#{Rails.root}/tmp/word-cloud-#{Time.now.to_i}.png"
        img.write(img_path)
        render json: {base_64: Base64.encode64(open(img_path).read)}
    end


end