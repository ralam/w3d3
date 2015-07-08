class ShortenedUrl < ActiveRecord::Base
  validates :short_url, uniqueness: true
  validates :user_id, :short_url, :long_url, presence: true

  belongs_to(
    :submitter,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(
    :visits,
    class_name: 'Visit',
    foreign_key: :short_url_id,
    primary_key: :id
  )

  has_many :visitors, -> { distinct }, through: :visits, source: :user

  def self.random_code
    code = SecureRandom.urlsafe_base64
    while self.exists?(short_url: code)
      code = SecureRandom.urlsafe_base64
    end

    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    self.create!(user_id: user.id, long_url: long_url, short_url: self.random_code)
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    uniq_ids = []
    visits.each do |visit|
      if visit.created_at > 10.minutes.ago && !uniq_ids.include?(visit.user_id)
        uniq_ids << visit.user_id
      end
    end

    uniq_ids.count
  end

end
