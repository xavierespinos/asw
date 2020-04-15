class Comentari < ApplicationRecord
	has_one :contribucion
	belongs_to :user
	has_many :comentaris
    validates :text, presence: true
end
