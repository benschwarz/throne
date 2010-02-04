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
      
      it "should create a design document with a list" do
        Throne::Request.should_receive(:put).with({:database=>:default, "list"=>"function(){send(toJSON({status: 'success'}))}", "_id"=>"_design/with_a_list", :resource=>"_design/with_a_list", "ruby_class"=>"Throne::Document"})
        Throne::DesignDocument.create("with_a_list", :list => "function(){send(toJSON({status: 'success'}))}")
      end
      
      it "should create a design document with a view" do
        Throne::Request.should_receive(:put).with({"_id"=>"_design/with_a_view", :resource=>"_design/with_a_view", "view"=>"function(doc){emit(doc)}", "ruby_class"=>"Throne::Document", :database=>:default})
        Throne::DesignDocument.create("with_a_view", :view => "function(doc){emit(doc)}")
      end
      
      it "must enforce that a design document view, list, show etc has a name"
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
      before :all do
        Throne::DesignDocument.create("dd-execute-spec", 
          :views => {:all => {:map => "function(doc) {emit(doc.id, doc)};"}}, 
          :lists => {:by_date => "function(head, req) {send(toJSON({}))}"}
        )
      end
      
      it "should respond to execute" do
        Throne::DesignDocument.should respond_to(:execute)
      end
      
      it "should require a major name" do
        lambda { Throne::DesignDocument.execute }.should raise_error(ArgumentError)
      end
      
      it "should execute the design document with only a full identifier " do
        Throne::DesignDocument.execute("dd-execute-spec/_view/all").should be_an_instance_of(Throne::Document)
      end
      
      it "should execute the design document with symbols"
      
      it "should merge params hash into query strings" do
        Throne::DesignDocument.execute("dd-execute-spec/_list/by_date/all", :params => {:descending => true})
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
        @design_doc.save.should be_true
      end

      it "should save the params sent through #save"
    end
    
    describe "destroy" do
      it "should respond to destroy" do
        @design_doc.should respond_to(:destroy)
      end
      
      it "should destroy and return true" do
        @design_doc.destroy.should be_true
        lambda { Throne::DesignDocument.get(@name) }.should raise_error(Throne::Document::NotFound)
      end
    end
  end
end