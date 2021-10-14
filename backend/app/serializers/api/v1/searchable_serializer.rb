module Api
  module V1
    module SearchableSerializer
      extend ActiveSupport::Concern

      included do
        attributes :type
      end

      def type
        object.class.name.demodulize.downcase.dasherize
      end
    end
  end
end
