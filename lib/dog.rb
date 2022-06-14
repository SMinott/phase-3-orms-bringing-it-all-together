class Dog
    attr_accessor :name, :breed, :id

    def initialize(name:, breed:, id: nil)
        @name = name
        @breed = breed
        @id = id
    end
# CREATE TABLE
    def self.create_table
        sql = <<-SQL
        CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT 
         )
        SQL

        DB[:conn].execute(sql)
    end

# DROP TABLE
    def self.drop_table
        sql = <<-SQL
          DROP TABLE IF EXISTS dogs
        SQL
    
        DB[:conn].execute(sql)
    end

# SAVE
    def save
    sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.breed)

    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end

# CREATE
    def self.create(name:, breed:)
        dog = Dog.new(name: name, breed: breed)
        dog.save
    end

# NEW
    def self.new_from_db(row)
        self.new(id: row[0], name: row[1], breed: row[2])
    end

# All
    def self.all
        sql = <<-SQL
        SELECT *
        FROM dogs
        SQL

        DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
    end
end

# FIND
    def self.new_from_db(row)
        self.new(id: row[0], name: row[1], breed: row[2])
    end

# FIND BY NAME
def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM dog
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

end

