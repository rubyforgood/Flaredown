class MergeTrackables::PatternIncludes
  include Sidekiq::Worker

  def perform(trackable_type, parent_id, rest_ids)
    parent = trackable_type.capitalize.constantize.find_by(id: parent_id)
    return unless parent

    Pattern.where("includes.id" => {"$in" => rest_ids}).map do |item|
      item.includes
        .select { |hash| hash[:category] == trackable_type.tableize && rest_ids.include?(hash[:id]) }
        .map do |selected_hash|
          selected_hash[:id] = parent_id
          selected_hash[:label] = parent.name
        end

      item.includes = item.includes.uniq
      item.save
    end

    MergeTrackables::PostTrackables.perform_async(trackable_type, parent_id, rest_ids)
  end
end
