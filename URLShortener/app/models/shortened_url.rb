class ShortenedUrl < ActiveRecord::Base
  validates :short_url, uniqueness: true
  validates :long_url, length: { maximum: 255 }
  validates :user_id, :short_url, :long_url, presence: true
  validate :cannot_create_more_than_five_in_prev_minute

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

  has_many(
    :taggings,
    class_name: 'Tagging',
    foreign_key: :short_url_id,
    primary_key: :id
  )

  has_many :visitors, -> { distinct }, through: :visits, source: :user

  has_many :tag_topics, through: :taggings, source: :topic

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
    Visit.where(
      "created_at > ? AND short_url_id = ? ", 10.minutes.ago, self.id
      ).select(:user_id).distinct.count
  end

  private
  def cannot_create_more_than_five_in_prev_minute
    recent_urls = ShortenedUrl
                    .where(
                    "created_at > ? AND user_id = ? ",
                    1.minute.ago, self.user_id
                    )
    if recent_urls.count >= 5
      errors[:count] << "Can't make more than five urls per minute"
    end
  end
end
