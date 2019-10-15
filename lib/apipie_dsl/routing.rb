module ApipieDSL
  module Routing
    module MapperExtensions
      def apipie_dsl(options = {})
        namespace 'apipie_dsl', path: ApipieDSL.configuration.doc_base_url do
          get 'apipie_dsl_checksum', to: 'apipie_dsls#apipie_dsl_checksum', format: 'json'
          constraints(version: /[^\/]+/, section: /[^\/]+/, class: /[^\/]+/,
                      method: /[^\/]+/) do
            get(options.reverse_merge("(:version)/(:section)/(:class)/(:method)" => 'apipie_dsls#index', as: :apipie_dsl))
          end
        end
      end
    end
  end
end

ActionDispatch::Routing::Mapper.send :include, ApipieDSL::Routing::MapperExtensions