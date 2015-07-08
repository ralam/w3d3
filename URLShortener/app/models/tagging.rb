class Tagging < ActiveRecord::Base
  validates :short_url_id, :tag_topic_id, presence: true

  belongs_to(
    :topic,
    class_name: 'TagTopic',
    foreign_key: :tag_topic_id,
    primary_key: :id
  )
  
  belongs_to(
    :short_url,
    class_name: 'ShortenedUrl',
    foreign_key: :short_url_id,
    primary_key: :id
  )
end
