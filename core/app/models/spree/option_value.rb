module Spree
  class OptionValue < Spree::Base
    belongs_to :option_type, class_name: 'Spree::OptionType', inverse_of: :option_values
    acts_as_list scope: :option_type

    has_many :option_values_variants, dependent: :destroy
    has_many :variants, through: :option_values_variants

    validates :name, presence: true, uniqueness: { scope: :option_type_id, allow_blank: true }
    validates :presentation, presence: true

    after_save :touch, if: :changed?
    after_touch :touch_all_variants

    self.whitelisted_ransackable_attributes = ['presentation']

    # Updates the updated_at column on all the variants associated with this
    # option value.
    def touch_all_variants
      variants.find_each(&:touch)
    end

    # @return [String] a string representation of all option value and its
    #   option type
    def presentation_with_option_type
      "#{self.option_type.presentation} - #{self.presentation}"
    end
  end
end
