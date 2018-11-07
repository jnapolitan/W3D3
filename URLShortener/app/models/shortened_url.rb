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
end
