require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Throne::Database do
  describe "setup" do
    it "should respond to setup" do
      Throne::Database.should respond_to :setup
    end
    
    it "should validate the database url on setup" do
      lambda { Throne::Database.setup(:validate, "git://git-repo.com") }.should raise_error(Throne::Database::URIError)
      lambda { Throne::Database.setup(:validate, "http://127.0.0.1/throne-valid") }
    end
    
    it "should list all the registered databases" do
      Throne::Database.setup(:default, "http://127.0.0.1/throne-specs")
      Throne::Database.list.should be_an_instance_of(Hash)
      Throne::Database.list.should include({:default => "http://127.0.0.1/throne-specs"})
    end
    
    it "should return the named database" do
      Throne::Database.setup(:validate, "http://127.0.0.1/throne-valid")
      Throne::Database[:validate].should == "http://127.0.0.1/throne-valid"
    end
    
    it "should raise when attempting to retrieve a database that has not been setup" do
      lambda { Throne::Database[:not_setup] }.should raise_error(Throne::Database::NotSetup)
    end
    
    it "should be setup" do
      Throne::Database.setup?(:default).should be_true
    end
    
    it "should not be setup" do
      Throne::Database.setup?(:not_setup).should be_false
    end
  end
  
  describe "with a database set" do
    before :all do
      Throne::Database.setup(:throne_database_specs, "http://127.0.0.1:5984/throne-database-specs")
      
      begin
        Throne::Database.destroy(:throne_database_specs)
      rescue RestClient::ResourceNotFound
      end
    end
    
    it "should create the database" do
      Throne::Database.create(:throne_database_specs)
      lambda { RestClient.get("http://127.0.0.1:5948/throne-database-specs") }.should_not raise_error(RestClient::ResourceNotFound)
    end
    
    it "should destroy the database" do
      Throne::Database.create(:throne_database_specs)
      Throne::Database.destroy(:throne_database_specs).should be_true
      lambda { Throne::Database.destroy(:throne_database_specs) }.should raise_error(RestClient::ResourceNotFound)
    end
    
    it "should not error when creating a database that exists" do
      Throne::Database.create(:throne_database_specs)
      lambda { Throne::Database.create(:throne_database_specs) }.should_not raise_error
    end
  end
end
