module Jekyll
  module AnchorLinksFilter
    #
    def anchor_links(input)
      input.gsub(/<h[1-6] .*?id="(.+?)".*?>/) do |s|
        s + '<a class="anchor-link" href="#' + $1 + '"></a> '
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::AnchorLinksFilter)
