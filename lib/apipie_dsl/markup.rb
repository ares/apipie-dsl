# frozen_string_literal: true

module ApipieDSL
  module Markup
    class RDoc
      def initialize
        require 'rdoc'
        require 'rdoc/markup/to_html'
        @rdoc ||= if Gem::Version.new(::RDoc::VERSION) < Gem::Version.new('4.0.0')
                    ::RDoc::Markup::ToHtml.new
                  else
                    ::RDoc::Markup::ToHtml.new(::RDoc::Options.new)
                  end
      end

      def to_html(text)
        @rdoc.convert(text)
      end
    end

    class Markdown
      def initialize
        require 'maruku'
      end

      def to_html(text)
        Maruku.new(text).to_html
      end
    end

    class Textile
      def initialize
        require 'RedCloth'
      end

      def to_html(text)
        RedCloth.new(text).to_html
      end
    end
  end
end
