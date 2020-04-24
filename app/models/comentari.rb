class Comentari < ApplicationRecord
	belongs_to :contribucion
	belongs_to :user
	has_many :comentaris
    validates :text, presence: true
end
