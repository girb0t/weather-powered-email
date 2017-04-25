class CreateLocationsTable < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TABLE cities(
        id SERIAL PRIMARY KEY NOT NULL,
        name  TEXT       NOT NULL,
        state VARCHAR(2) NOT NULL
      )
    SQL
  end

  def down
    execute <<-SQL
      DROP TABLE cities;
    SQL
  end
end
