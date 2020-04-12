class Contribucion < ApplicationRecord
  has_one :user
	default_scope -> { order(points: :desc) }
	validate :onlyAskOrURL
	validate :needAskOrURL
	validates :title, presence: true
	validate :uri?
  #validates_uniqueness_of :url
  
  def uri?
    if text == ""
      uri = URI.parse(url)
      if !(uri.is_a?(URI::HTTP) && !uri.host.nil?) 
        errors.add(:url, "not valid")
      end
    end
  end
  
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
