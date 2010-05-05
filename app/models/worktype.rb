class Worktype < ActiveRecord::Base
  attr_accessible :name, :price_per_hour

  validate :price_must_be_at_least_a_cent

  # Bugfix work type finder
  def self.bugfix
    self.find_by_name "bugfix"
  end

  # Returns work types for Rails form select helper
  def self.find_for_select
    self.all.collect { |w| [ w.name, w.id ] }
  end

  # Prevent of deletion of 'bugfix' work type
  def before_destroy
    if name == "bugfix"
      raise "Can't delete 'bugfix' work type"
    end
  end

  protected

  def price_must_be_at_least_a_cent
    errors.add(:price_per_hour, 'should be at least 0.01') if price_per_hour.nil? || price_per_hour < 0.01
  end
end
