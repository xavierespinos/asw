class Comentari < ApplicationRecord
	has_one :contribucion
    validates :text, presence: true
end
