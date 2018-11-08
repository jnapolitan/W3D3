# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortenedUrl < ApplicationRecord
  validates :long_url, :short_url, :user_id, presence: true
  
  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User
    
  has_many :visits,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :Visit
    
  has_many :visitors,
    -> { distinct },
    through: :visits,
    source: :visitor
  
  def self.random_code
    code = SecureRandom.urlsafe_base64
    
    until !ShortenedUrl.exists?(:short_url => code)
      code = SecureRandom.urlsafe_base64
    end
    
    code
  end
  
  def self.create_with_user(user, long_url)
    s = ShortenedUrl.new(long_url: long_url, short_url: ShortenedUrl.random_code, user_id: user.id)
    s.save
  end
  
  def num_clicks
    self.visits.count
  end
  
  def num_uniques
    self.visitors.count
  end
  
  def num_recent_uniques
    num = self.visits.where({ created_at: (Time.now - 10.minutes)..Time.now }).count
    num == 0 ? (raise "No recent visits!") : num
  end
  
end
