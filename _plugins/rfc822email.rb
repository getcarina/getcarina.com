module Jekyll
  module RFC822EmailFilter
    def rfc822name(input)
      match = /(.+?) <(.+?)>/.match(input)

      if match != nil
        match[1]
      else
        input
      end
    end

    def rfc822email(input)
      match = /(.+?) <(.+?)>/.match(input)

      if match != nil
        match[2]
      else
        ''
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::RFC822EmailFilter)
