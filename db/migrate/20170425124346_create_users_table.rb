class CreateUsersTable < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TABLE users(
        id SERIAL PRIMARY KEY NOT NULL,
        email   TEXT NOT NULL UNIQUE,
        city_id INT  NOT NULL
      );
    SQL
  end

  def down
    execute <<-SQL
      DROP TABLE users;
    SQL
  end
end
