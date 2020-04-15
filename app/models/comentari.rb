class Comentari < ApplicationRecord
	has_one :contribucion
	has_many :comentaris, as: :commentable
    validates :text, presence: true
end
