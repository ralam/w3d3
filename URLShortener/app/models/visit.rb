class Visit < ActiveRecord::Base
  validates :user_id, :short_url_id, presence: true

  belongs_to(
    :user,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )

  belongs_to(
    :shortened_url,
    class_name: 'ShortenedUrl',
    foreign_key: :short_url_id,
    primary_key: :id
  )
end
