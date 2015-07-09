class TagTopic < ActiveRecord::Base
  validates :topic, presence: true, uniqueness: true

  has_many(
    :taggings,
    class_name: 'Tagging',
    foreign_key: :tag_topic_id,
    primary_key: :id
  )

  has_many :short_urls, through: :taggings, source: :short_url

  def self.popular(topic, n = 1)
    self
      .find_by(topic: topic)
      .short_urls
      .sort_by(&:num_clicks)
      .last(n)
  end
end
