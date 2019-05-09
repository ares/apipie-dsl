# frozen_string_literal: true

module ApipieDSL
  class SeeDescription
    attr_reader :link, :description

    def initialize(args)
      if args.first.is_a?(Hash)
        args = args.first
      elsif args.count == 2
        args = if args.last.is_a?(Hash)
                 { link: args.first }.merge(args.last)
               else
                 { link: args.first, description: args.second }
               end
      elsif args.count == 1 && args.first.is_a?(String)
        args = { link: args.first, description: args.first }
      else
        raise ArgumentError 'ApipieDSLError: Bad use of see method.'
      end
      @link = args[:link] || args['link']
      @description = args[:desc] || args[:description] || args['desc'] || args['description']
    end

    def to_hash
      { link: see_url, description: description }
    end

    def see_url
      method_description = ApipieDSL.get_method_description(@link)
      raise ArgumentError, "Method #{@link} referenced in 'see' does not exist." if method_description.nil?

      method_description.doc_url
    end
  end
end
