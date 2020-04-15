class Comentari < ApplicationRecord
	has_one :contribucion
	has_many :comentaris
    validates :text, presence: true
end
