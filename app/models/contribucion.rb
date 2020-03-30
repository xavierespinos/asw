class Contribucion < ApplicationRecord
	#belongs_to :user
	default_scope -> { order(points: :desc) }
	validate :onlyAskOrURL
	validate :needAskOrURL
	validates :title, presence: true
	
  def onlyAskOrURL 
    if url != "" and text != ""
      errors.add(:url, "can't have url and text")
      errors.add(:text,"can't have url and text")
    end
  end
  
  def needAskOrURL 
    if url == "" and text == ""
      errors.add(:url, "url or text is required")
      errors.add(:text,"url or text is required")
    end
  end
  
end
