class Contribucion < ApplicationRecord
	#belongs_to :user
	default_scope -> { order(points: :desc) }
	
end
