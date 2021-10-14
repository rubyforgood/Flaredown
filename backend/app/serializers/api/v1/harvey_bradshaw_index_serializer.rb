module Api
  module V1
    class HarveyBradshawIndexSerializer < ApplicationSerializer
      attributes :id, :abdominal_mass, :abdominal_pain, :abscess, :anal_fissure, :aphthous_ulcers, :arthralgia, :score,
        :erythema_nodosum, :new_fistula, :pyoderma_gangrenosum, :stools, :uveitis, :well_being, :checkin_id
    end
  end
end
