#
# A lightweight data structure to hold onboarding and checkin processes steps,
# each with pointers to previous and next steps
#

class Step
  include ActiveModel::Serialization

  attr_accessor :id, :group, :priority, :key

  def initialize(id, group, priority, key)
    @id = id
    @group = group
    @priority = priority
    @key = key
  end

  def prev_id
    (priority > 1) ? id-1 : nil
  end

  def next_id
    max_priority = self.class.by_group(group).sort_by { |step| step.priority}.last.priority
    (priority < max_priority) ? id+1 : nil
  end

  class << self

    def all
      @@all ||= begin
        result = []
        all_hash = {
          onboarding: %w(
            personal
            demographic
            conditions
            symptoms
            treatments
            completed
          ),
          checkin: %w(
            start
            conditions
            symptoms
            treatments
            tags
          )
        }
        offset = 0
        all_hash.each_with_index do |item, i|
          group, steps = item[0], item[1]
          steps.each_with_index { |key, j| result << new(offset+j+1, group, j+1, key) }
          offset += steps.count
        end
        result
      end
    end

    def by_group(group)
      self.all.select { |step| step.group.eql? group }
    end

    def find(id)
      self.all.find { |step| step.id.eql? id }
    end

    def find_by_key(key)
      self.all.find { |step| step.key.eql? key }
    end

  end

end
