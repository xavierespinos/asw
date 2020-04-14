class Comentari < ApplicationRecord
<<<<<<< HEAD
    belongs_to :commentable, polymorphic: true
	has_one :contribucion
	has_many :comentaris, as: :commentable
=======
	has_one :contribucion
>>>>>>> 1f67ed81d96e4905dfe1fa3ee5793d7cb513b3e7
    validates :text, presence: true
end
