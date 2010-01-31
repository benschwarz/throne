require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Throne::DesignDocument do
  describe "class" do
    describe "new" do
      it "should require a major name" do
        lambda { Throne::DesignDocument.new }.should raise_error(ArgumentError)
      end
    end
    
    describe "create" do
      it "should respond to create" do
        Throne::DesignDocument.should respond_to(:create)
      end
      
      it "should require a major name" do
        lambda { Throne::DesignDocument.create }.should raise_error(ArgumentError)
      end
      
      it "should return an instance of self" do
        Throne::DesignDocument.create("instance_of_self").should be_an_instance_of(Throne::DesignDocument)
      end
      
      it "should create a design document with a list"
      it "should create a design document with a view"
    end
    
    describe "get" do
      it "should respond to get" do
        Throne::DesignDocument.should respond_to(:create)
      end
      
      it "should require a major name" do
        lambda { Throne::DesignDocument.get }.should raise_error(ArgumentError)
      end
      
      it "should get the design document" do
        name = "named_design_document"
        Throne::DesignDocument.create(name)
        Throne::DesignDocument.get(name).should be_an_instance_of(Throne::DesignDocument)
      end
    end
    
    describe "execute" do
      it "should respond to execute" do
        Throne::DesignDocument.should respond_to(:execute)
      end
      
      it "should require a major name" do
        lambda { Throne::DesignDocument.execute }.should raise_error(ArgumentError)
      end
      
      it "should execute the design document with only a full identifier" do
        name = "full_identifier"
        RestClient.should_receive(:get).with("http://127.0.0.1:5984/throne-specs/_design/#{name}/_view/view-name", {:accept_encoding=>"gzip, deflate"})
        Throne::DesignDocument.execute("#{name}/_view/view-name")
      end
      
      it "should execute the design document with symbols"
      
      it "should merge params hash into query strings" do
       name = "params-to-query-strings" 
       RestClient.should_receive(:get).with("http://127.0.0.1:5984/throne-specs/_design/#{name}/_list/list-name/view-name?descending=true", {:accept_encoding=>"gzip, deflate"})
        Throne::DesignDocument.execute("#{name}/_list/list-name/view-name", :params => {:descending => true})
      end
      
      it "should return the result of the design document"
    end
    
    describe "destroy" do
      it "should respond to destroy" do
        Throne::DesignDocument.should respond_to(:destroy)
      end
      
      it "should require a major name" do
        lambda { Throne::DesignDocument.destroy }.should raise_error(ArgumentError)
      end
      
      it "should destroy and return true" do
        Throne::DesignDocument.destroy(@name).should be_true
        lambda { Throne::DesignDocument.get(@name) }.should raise_error(Throne::Document::NotFound)
      end
    end
  end
  
  describe "instance" do
    before :all do
      @name = "design-doc-instance"
      @design_doc = Throne::DesignDocument.create(@name)
    end
    
    describe "save" do
      it "should respond to save" do
        @design_doc.should respond_to(:save)
      end

      it "should save the design document" do
        RestClient.should_receive(:put).with("http://127.0.0.1:5984/throne-specs/_design/#{@name}", "{\"_rev\":\"1-fd0d5d7a365f0463d7caba1a2a002fd4\",\"_id\":\"_design/design-doc-instance\",\"ruby_class\":\"Throne::Document\"}", {:accept_encoding=>"gzip, deflate"})
        @design_doc.save
      end

      it "should save the params sent through #save"
    end
    
    describe "destroy" do
      it "should respond to destroy" do
        @design_doc.should respond_to(:destroy)
      end
      
      it "should require a major name" do
        lambda { @design_doc.destroy }.should raise_error(ArgumentError)
      end
      
      it "should destroy and return true" do
        @design_doc.destroy.should be_true
        lambda { Throne::DesignDocument.get(@name) }.should raise_error(Throne::Document::NotFound)
      end
    end
  end
end