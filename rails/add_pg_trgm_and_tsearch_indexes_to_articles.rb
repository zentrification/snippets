# Lets say you ran a
#    `rails g model article author:string content:text summary:text title:string
#
# Your using Postgres, and you want fast search on this model
#
class AddPgTrgmAndTsearchIndexesToArticles < ActiveRecord::Migration

  @columns = [:author, :content, :summary, :title]

  def self.up
    # pg_trgm indexes
    ############################################################
    @columns.each do |col|
      execute "CREATE INDEX #{col}_trgm_idx ON articles using gin(#{col} gin_trgm_ops)"
    end

    # tsearch
    # - tsvector column (searchable_tsv)
    # - update tsvector on existing rows
    # - trigger to updated tsvector column
    # - index on tsvector column
    ############################################################
    @tsvector_conversion = @columns.map do |col|
      "to_tsvector('pg_catalog.english', coalesce(#{col}, ''))"
    end

    add_column :articles, :searchable_tsv, :tsvector

    execute "UPDATE articles SET searchable_tsv = #{@tsvector_conversion.join(' || ')}"

    execute <<-EOS
      CREATE TRIGGER searchable_tsv_update
      BEFORE INSERT OR UPDATE ON article
      FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(searchable_tsv, 'pg_catalog.english', #{@columns.join(', ')});
    EOS

    execute 'CREATE INDEX searchable_tsv_idx ON articles using gin(searchable_tsv)'
  end

  def self.down
    @columns.each do |col|
      execute "DROP INDEX IF EXISTS #{col}_trgm_idx"
    end
    remove_column :articles, :searchable_tsv
    execute 'DROP TRIGGER searchable_tsv_update ON articles'
    execute 'DROP INDEX IF EXISTS searchable_tsv_idx'
  end

end
