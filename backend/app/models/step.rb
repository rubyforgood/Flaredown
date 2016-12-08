#
# A lightweight data structure to hold onboarding and checkin processes steps,
# each with pointers to previous and next steps
#

class Step
  include ActiveModel::Serialization

  attr_accessor :id, :priority

  def initialize(id, priority)
    @id = id
    @priority = priority
  end

  def group
    id.split('-')[0].to_sym
  end

  def key
    id.split('-')[1].to_sym
  end

  def prev_id
    Store.instance.all_hash[id][:earlier].id
  rescue
    nil
  end

  def next_id
    Store.instance.all_hash[id][:later].id
  rescue
    nil
  end

  SEEDS = {
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
      foods
      tags
      summary
    )
  }

  class << self
    def all
      Store.instance.all
    end

    def all_hash
      Store.instance.all_hash
    end

    def by_group(group)
      all.select { |step| step.group.eql? group }
    end

    def find(id)
      all_hash[id][:current]
    rescue
      nil
    end
  end

  class Store
    include Singleton
    attr_reader :all, :all_hash

    def initialize
      # Build @all_hash
      @all_hash = {}
      SEEDS.each do |seed|
        group = seed[0]
        steps = seed[1]
        steps.each_with_index do |step, i|
          current_key = "#{group}-#{step}"
          earlier =
            if i == 0
              nil
            else
              earlier_key = "#{group}-#{steps[i - 1]}"
              @all_hash[earlier_key][:current]
            end
          current = Step.new(current_key, i + 1)
          @all_hash[current_key] = {
            current: current,
            earlier: earlier
          }
          @all_hash[key_for(earlier)][:later] = current if earlier.present?
        end
      end
      # Build @all
      @all = @all_hash.values.map { |v| v[:current] }
    end

    def key_for(step)
      "#{step.group}-#{step.key}"
    end
  end

end
