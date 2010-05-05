class Grant < ActiveRecord::Base
  attr_accessible :name, :budget

  validate :budget_must_be_at_least_a_cent

  # Returns work types for Rails form select helper
  def self.find_for_select
    self.all.collect { |w| [ w.name, w.id ] }
  end


  protected

  def budget_must_be_at_least_a_cent
    errors.add(:price_per_hour, 'should be at least 0.01') if budget.nil? || budget < 0.01
  end
end
