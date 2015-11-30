class PlaceGroup < ActiveRecord::Base
  has_many :messages, as: :with_message, dependent: :destroy
  has_many :places, dependent: :nullify
  belongs_to :user
  validates :name, presence: true
  validates :user_id, presence: true
  validate :must_be_general


  def must_be_general
    if !user.general?
      errors.add(:user_id, I18n.t('models.place_groups.errors.not_general'))
    end
  end
end
