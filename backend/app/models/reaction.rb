class Reaction
  include Mongoid::Document

  field :value,             type: String
  field :encrypted_user_id, type: String, encrypted: { type: :integer }

  validates :value, :reactable, :encrypted_user_id, presence: true

  belongs_to :reactable, polymorphic: true

  def self.values_count_with_participated(encrypted_user_id)
    map_count = <<-JS.strip_heredoc
      function() {
        emit(
          this.value,
          {
            total: 1,
            encrypted_user_id: this.encrypted_user_id
          }
        );
      }
    JS

    reduce_count = <<-JS.strip_heredoc
      function(key, valuesGroup){
        var r = {
          total: 0,
          participated: false,
        };

        for (var idx  = 0; idx < valuesGroup.length; idx++) {
          var value = valuesGroup[idx];

          r.total += valuesGroup[idx].total;

          if (!r.participated && value.encrypted_user_id === "#{encrypted_user_id}") {
            r.participated = true;
          }
        }

        return r;
      }
    JS

    map_reduce(map_count, reduce_count).out(inline: true).to_a
  end
end
