# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: chapters
#
#  id                     :integer          not null, primary key
#  canonical_title        :string           default("en_jp"), not null
#  length                 :integer
#  number                 :integer          not null
#  published              :date
#  synopsis               :text
#  thumbnail_content_type :string(255)
#  thumbnail_file_name    :string(255)
#  thumbnail_file_size    :integer
#  thumbnail_meta         :text
#  thumbnail_updated_at   :datetime
#  titles                 :hstore           default({}), not null
#  volume_number          :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  manga_id               :integer          indexed
#
# Indexes
#
#  index_chapters_on_manga_id   (manga_id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Chapter, type: :model do
  subject { create(:chapter) }
  let(:manga) { create(:manga) }

  it { should belong_to(:manga).required }
  it { should validate_presence_of(:number) }
  it 'should strip XSS from synopsis' do
    subject.synopsis = '<script>prompt("PASSWORD:")</script>' * 3
    subject.save!
    expect(subject.synopsis).not_to include('<script>')
  end
end
