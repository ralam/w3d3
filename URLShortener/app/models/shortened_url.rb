class ShortenedUrl < ActiveRecord::Base
  validates :short_url, presence: true, uniqueness: true
  validates :user_id, presence: true
  validates :long_url, presence: true

  belongs_to(
    :submitter,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )

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

end
