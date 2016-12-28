class Food < ActiveRecord::Base
  LANG_MAP = {
    en: :english,
    it: :italian
  }

  translates :long_desc, :shrt_desc, :comname, :sciname

  class << self
    def fts(query, limit)
      sql = <<-SQL.strip_heredoc
        SELECT id, name, searchable
        FROM (
          SELECT
            to_tsvector(:lang, ft.long_desc) AS searchable,
            foods.id AS id,
            ft.long_desc AS name
          FROM foods
          INNER JOIN food_translations AS ft ON ft.food_id = foods.id
          WHERE ft.locale = :locale
        ) f
        WHERE f.searchable @@ to_tsquery(:lang, :query)
        ORDER BY ts_rank_cd(f.searchable, to_tsquery(:lang, :query), 1) DESC
        LIMIT :limit
      SQL

      find_by_sql([
        sql,
        {
          lang: LANG_MAP[I18n.locale] || :simple,
          query: query.strip.split(/(\s*,\s*)|\s+/).map { |s| "#{s}:*" }.join('&'),
          limit: limit,
          locale: I18n.locale
        }
      ])
    end
  end
end
