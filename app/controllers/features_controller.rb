class FeaturesController < ApplicationController


    def heat_map
        @points = Rails.cache.fetch(["heat_map"]) do
            MongoHelper.load_map_points
        end
        render "heat_map"
    end


    def get_cloud_path
        path = Rails.cache.fetch(["get_cloud_path"]) do
            words = MongoHelper.word_cloud_data[0..100]
            cloud = MagicCloud::Cloud.new(words, rotate: :free, scale: :log)
            img = cloud.draw(1200, 800) #default height/width
            img_path = "#{Rails.root}/tmp/word-cloud-#{Time.now.to_i}.png"
            img.write(img_path)
            img_path
        end
        render json: {base_64: Base64.encode64(open(path).read)}
    end


    def fake_users
        respond_to do |format|
          format.html
          format.json { render json: FakeUsersDatatable.new(view_context) }
        end
    end


  def get_numero_de_seguidores
    @usuarios = Rails.cache.fetch(["get_numero_de_seguidores"]) do
        MongoHelper.get_usuarios_grau_de_entrada.map{|u| TwitterHelper.get_user_data(u)}
    end
    render partial: 'usuarios', layout: false
  end

  def get_grau_de_entrada

    @icon="fa-sort-numeric-asc"

    usuarios = {
        "babibitch794": 43898,
        "rayannemendesss": 34481,
        "ricardin_reborn": 33603,
        "akapretocaro": 16736,
        "meowgguk": 14592,
        "luscatic": 13888,
        "alvxaro": 13784,
        "thomassantanas": 8573,
        "gentlepvnk": 6248,
        "stwfunny": 6170
    }

    @usuarios = Rails.cache.fetch(["get_usuarios_grau_de_entrada"]) do
        usuarios.keys.map{|u|
            data = TwitterHelper.get_user_data(u).to_h.transform_keys(&:to_sym)
            data[:number] = usuarios[u]
            data
        }
    end
    render partial: 'usuarios', layout: false
  end


  def get_page_rank

    @icon="fa-file-text-o"

    usuarios = {
        "babibitch794": 1.0,
        "gaaarfielddd": 0.850034089532,
        "rayannemendesss": 0.812494396667,
        "ricardin_reborn": 0.788034984277,
        "augusttovieira": 0.723276153709,
        "frauveadeira": 0.614978188747,
        "alvxaro": 0.455154658286,
        "akapretocaro": 0.416270141685,
        "jairsoncardosoo": 0.394641986812,
        "meowgguk": 0.300108719498
    }

    @usuarios = Rails.cache.fetch(["get_usuarios_page_rank"]) do
        usuarios.keys.map{|u|
            data = TwitterHelper.get_user_data(u).to_h.transform_keys(&:to_sym)
            data[:number] = usuarios[u]
            data
        }
    end
    render partial: 'usuarios', layout: false
  end



  def get_betweeness

    @icon="fa-arrows-alt"

    usuarios = {
        "akapretocaro": 1.0,
        "babibitch794": 0.319443691482,
        "gaaarfielddd": 0.212960748988,
        "NicolyAndrades1": 0.17020250671,
        "frdclh": 0.118193874808,
        "alvxaro": 0.107628270133,
        "augusttovieira": 0.106541150475,
        "duuhads6": 0.104924594984,
        "svetenapolitino": 0.0843478737252,
        "sdsotnaselocin": 0.0574150120667
    }

    @usuarios = Rails.cache.fetch(["get_usuarios_betweeness"]) do
        usuarios.keys.map{|u|
            data = TwitterHelper.get_user_data(u).to_h.transform_keys(&:to_sym)
            data[:number] = usuarios[u]
            data
        }
    end
    render partial: 'usuarios', layout: false
  end




end