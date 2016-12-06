class Food < ActiveRecord::Base
  translates :long_desc, :shrt_desc, :comname, :sciname
end
