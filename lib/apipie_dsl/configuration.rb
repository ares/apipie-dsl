# frozen_string_literal: true

module ApipieDSL
  class Configuration
    attr_accessor :app_name, :copyright, :markup, :doc_base_url, :layout,
                  :default_version, :debug, :version_in_url, :validate,
                  :doc_path, :languages, :link_extension, :translate, :locale,
                  :default_locale, :class_full_names, :autoload_methods,
                  :dsl_classes_matcher, :sections, :authenticate, :authorize,
                  :use_cache
    attr_writer   :validate_value, :ignored, :reload_dsl,
                  :dsl_classes_matchers
    attr_reader   :app_info, :dsl_base_url

    alias_method :validate?, :validate
    alias_method :class_full_names?, :class_full_names
    alias_method :autoload_methods?, :autoload_methods
    alias_method :use_cache?, :use_cache

    def validate_value
      (validate? && @validate_value)
    end
    alias_method :validate_value?, :validate_value

    # array of class names (strings) (might include methods as well)
    # to be ignored when generationg the documentation
    # e.g. %w[DSL::MyClass DSL::IO#puts]
    def ignored
      @ignored ||= []
      @ignored.map(&:to_s)
    end

    def dsl_base_url=(url)
      version = ApipieDSL.configuration.default_version
      @dsl_base_url[version] = url
    end

    def app_info=(description)
      version = ApipieDSL.configuration.default_version
      @app_info[version] = description
    end

    def dsl_classes_matchers
      unless @dsl_classes_matcher.empty?
        @dsl_classes_matchers << @dsl_classes_matcher
      end
      @dsl_classes_matchers = @dsl_classes_matchers.uniq
    end

    def reload_dsl?
      @reload_dsl = if defined? Rails
                          Rails.env.development?
                        else
                          @reload_dsl
                        end
      @reload_dsl && !dsl_classes_matchers.empty?
    end

    def initialize
      @markup = ApipieDSL::Markup::RDoc.new
      @app_name = 'Another DOC'
      @app_info = {}
      @copyright = nil
      @validate = :implicitly
      @validate_value = true
      @dsl_base_url = {}
      @doc_base_url = '/apipie-dsl'
      @layout = 'apipie_dsl/apipie_dsl'
      @default_version = '1.0'
      @debug = false
      @version_in_url = true
      @doc_path = 'doc'
      @link_extension = '.html'
      @languages = []
      @default_locale = 'en'
      @locale = lambda { |_locale| @default_locale }
      @translate = lambda { |str, _locale| str }
      @class_full_names = false
      @autoload_methods = false
      @dsl_classes_matcher = ''
      @dsl_classes_matchers = []
      @sections = [:all]
    end
  end
end
