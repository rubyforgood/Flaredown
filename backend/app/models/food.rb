class Food < ActiveRecord::Base
  LANG_MAP = {
    en: :english,
    it: :italian
  }.freeze

  has_many :food_translations, class_name: 'Food::Translation'

  translates :long_desc, :shrt_desc, :comname, :sciname

  alias name long_desc

  class << self
    def fts(query, limit, user_id)
      find_by_sql(
        [
          fts_sql,
          {
            user_id: user_id,
            lang: LANG_MAP[I18n.locale] || :simple,
            query: query.strip.split(/(\s*,\s*)|\s+/).map { |s| "#{s}:*" }.join('&'),
            limit: limit,
            locale: I18n.locale
          }
        ]
      )
    end

    private

    def fts_sql
      <<-SQL.strip_heredoc
        SELECT id, long_desc, searchable, global
        FROM (
          SELECT
            to_tsvector(:lang, ft.long_desc) AS searchable,
            foods.id AS id,
            foods.global AS global,
            ft.long_desc AS long_desc
          FROM foods
          INNER JOIN food_translations AS ft ON ft.food_id = foods.id
          WHERE ft.locale = :locale AND foods.id IN (
            SELECT uf.food_id
            FROM user_foods AS uf
            WHERE uf.user_id = :user_id
          ) OR foods.global IS TRUE
        ) f
        WHERE f.searchable @@ to_tsquery(:lang, :query)
        ORDER BY ts_rank_cd(f.searchable, to_tsquery(:lang, :query), 1) DESC
        LIMIT :limit
      SQL
    end
  end
end
