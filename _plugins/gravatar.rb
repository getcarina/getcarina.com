# This is the Jekyll Gravatar Filter
#
# Place this file in your plugins directory
#
# Usage:
#     {{ email@domain.com | gravatar }}
#
#   You may want to set up those settings in _config.yml:
#
#     gravatar:
#       default_image: mm
#       size: 20
#       rating: g
#       secure: true
#       force: y
#
#   Look at https://en.gravatar.com/site/implement/images/ to get know what values you can use
#
#   If you are in a need of having different settings for different contexts
#   like pages or posts then you can add context:
#     gravatar:
#       some_context:
#         size: 20
#         force: y
#       some_other_context:
#         size: 80
#       size: 40
#       default_image: mm
#   And use it like that:
#     {{ email | gravatar:'some_context' }}
#
#   Any argument missing in context are taken from default settings or,
#   if none provided, are set to nil
#
#
# Michał Ostrowski, <ostrowski.michal@gmail.com>
# repo@github: https://github.com/espresse/jekyll_gravatar_filter
#
# blog: http://espresse.net
#
require 'digest/md5'

module Jekyll
  module GravatarFilter
    def gravatar(email_address, gravatar_mode=nil)
      @gravatar_mode = gravatar_mode
      email_address ||= ""
      gravatar_url(email_address)
    end

    private

    def gravatar_url(email_address)
      url = "#{gravatar_protocol}://www.gravatar.com/avatar/#{gravatar_hash(email_address)}"
      url += "?" + gravatar_options.join('&') unless gravatar_options.empty?
      url
    end

    def gravatar_protocol
      protocol = gravatar_config["secure"] ? "https" : "http"
    end

    def gravatar_hash(email_address)
      hash = Digest::MD5.hexdigest(email_address.downcase.gsub(/\s+/, ""))
    end

    def gravatar_config
      return @gravatar_config if @gravatar_config

      @gravatar_config = Jekyll.configuration({})['gravatar'] || {}

      unless @gravatar_config.empty?
        mode_config = (@gravatar_mode and @gravatar_config[@gravatar_mode]) ? @gravatar_config[@gravatar_mode] : @gravatar_config
        @gravatar_config = @gravatar_config.merge mode_config
      end
      @gravatar_config
    end

    def gravatar_options
      opts = []
      opts.push "s=#{gravatar_config['size']}" if gravatar_config["size"]
      opts.push "r=#{gravatar_config['rating']}" if gravatar_config["rating"]
      opts.push "d=#{gravatar_config['default_image']}" if gravatar_config["default_image"]
      opts.push "f=#{gravatar_config['force']}" if gravatar_config['force']
      opts
    end
  end
end
Liquid::Template.register_filter(Jekyll::GravatarFilter)
