class AddLongDescVectorIndexOnFoodTranslations < ActiveRecord::Migration
  disable_ddl_transaction!

  def up
    Food::LANG_MAP.each do |short_lang, long_lang|
      drop_index(short_lang)

      execute <<-SQL.strip_heredoc
        CREATE INDEX CONCURRENTLY idx_fts_food_translations_#{short_lang} ON food_translations
        USING gin(to_tsvector('#{long_lang}', long_desc))
        WHERE locale = '#{short_lang}';
      SQL
    end
  end

  def down
    Food::LANG_MAP.each do |short_lang, long_lang|
      drop_index(short_lang)
    end
  end

  private

  def drop_index(short_lang)
    execute "DROP INDEX CONCURRENTLY IF EXISTS idx_fts_food_translations_#{short_lang}"
  end
end
