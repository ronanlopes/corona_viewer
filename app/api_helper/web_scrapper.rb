class WebScrapper

	def self.g1_noticias(url="https://g1.globo.com/tudo-sobre/corona/")

		page = open(url) { |f| Nokogiri::HTML(f) }
		page.css(".bastian-feed-item").map{|n|
			{
				img: n.css("img").first.to_s,
				title: n.css(".feed-post-link").text,
				date: n.css(".feed-post-metadata").children.map(&:text).map(&:strip).join(" - "),
				link: n.css(".feed-post-link").attr("href").to_s
			}
		}

	end


end