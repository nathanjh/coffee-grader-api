# generic search service object to be used for 'search' controller actions
# NOTE: pass a valid db table name (string) along with an array of the column
# names you'd like to search to ::new eg. Search.new('users', ['email', 'name'])
class Search
  def initialize(table, columns)
    raise no_table_error_message(table) unless valid_table?(table)
    @table = table
    raise no_column_error_message(columns) unless valid_columns?(columns)
    @columns = columns
  end

  def call(term)
    term = "%#{term}%"
    table_model.where(sql_query, term: term)
  end

  private

  def valid_table?(table)
    ActiveRecord::Base.connection.data_source_exists? table
  end

  def valid_columns?(columns)
    columns.each do |col|
      return false unless table_column_names.include?(col)
    end
    true
  end

  def no_table_error_message(table)
    "No such table: #{table}, in current database.#{capitalization_check(table)}"
  end

  def no_column_error_message(columns)
    message = ''
    columns.each do |col|
      unless table_column_names.include?(col)
        message += "No such column: #{col}, "
      end
    end
    message += "on #{@table} table."
  end

  def table_column_names
    table_model.column_names
  end

  def table_model
    # silly string manipulation to get a model name to check for column names
    @table.chomp('s').capitalize.constantize
  end

  def capitalization_check(table)
    " Did you mean #{table.downcase}?" if valid_table?(table.downcase)
  end

  # possible postgres dependency with 'ILIKE' for case insesitive matching
  def sql_query
    query = "#{@columns[0]} ILIKE :term "
    return query unless @columns.length > 1

    @columns[1..-1].each { |col| query += "OR #{col} ILIKE :term " }
    query
  end
end
