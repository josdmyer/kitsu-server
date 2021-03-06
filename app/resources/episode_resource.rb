class EpisodeResource < BaseResource
  caching

  attributes :titles, :canonical_title, :season_number, :number, :relative_number, :synopsis,
    :airdate, :length
  attribute :thumbnail, format: :attachment

  has_one :media, polymorphic: true
  has_many :videos

  filters :media_id, :media_type
  filter :number, verify: ->(values, _context) { values.map(&:to_i) }

  def length
    _model.length / 60 if _model.length
  end
end
