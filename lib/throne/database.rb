class Throne::Database  
  class NotSetup < StandardError; end
  class URIError < StandardError; end
  
  class << self
    @@databases = {}
    
    # Setup a database
    # @params [Symbol] The name of the connection 
    # @params [String] The uri of the database
    def setup(name, uri)
      raise URIError, "not a valid database URI" unless valid?(uri)
      @@databases[name] = uri
    end
    
    # Is the named connection setup? 
    # @params [Symbol] The name of the connection
    # @return [TrueClass]
    def setup?(name)
      @@databases.key? name
    end
    
    # Create the database
    # @params [Symbol] Name of the database to use (that has been setup using the setup method)
    def create(db)
      Throne::Request.put :database => db
    rescue RestClient::RequestFailed => e
      super unless e.message =~ /412$/
    end
    
    # Destroy the database
    # @params [Symbol] Name of the database to use (that has been setup using the setup method
    # @return [TrueClass]
    def destroy(db)
      Throne::Request.delete :database => db
    end
    
    # List the databases that you've :setup
    # @return [Hash]
    def list
      @@databases
    end
    
    # Retrieve a named database URI
    def [](name)
      raise NotSetup, "#{name} has not been setup. Check the docs for Throne::Database.setup" unless @@databases.key? name
      @@databases[name]
    end
    
    private
    
    # Checks weather the URI is valid
    # URIs must be http or https
    # @params [String] A URI
    # @return [TrueClass]
    def valid?(uri)
      ["http", "https"].include?(URI.parse(uri).scheme)
    end
  end
end
