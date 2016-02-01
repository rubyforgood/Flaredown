class ChartSerializer < ApplicationSerializer
  attributes  :id,
              :start_at,
              :end_at


  has_many :checkins, embed: :ids, embed_in_root: true

  has_many :trackings, embed: :ids, embed_in_root: true
end
