class Comentari < ApplicationRecord
    belongs_to :commentable, polymorphic: true
	has_one :contribucion
	has_many :comentaris, as: :commentable
    validates :text, presence: true
end
