# == Schema Information
#
# Table name: visits
#
#  id               :bigint(8)        not null, primary key
#  user_id          :integer          not null
#  shortened_url_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Visit < ApplicationRecord
  def self.record_visit!(user, shortened_url)
    v = Visit.new(user_id: user.id, shortened_url_id: shortened_url.id)
    v.save
  end
end

