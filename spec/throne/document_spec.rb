require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Throne::Document do
  before :all do
    Throne::Database.setup(:document_specs, "http://127.0.0.1:5984/throne-document-specs")
    
    class TestDocument < Throne::Document
      database :document_specs
    end
    
    class TestDocumentWithDefault < Throne::Document
    end
    
    Throne::Database.create(:default)
    Throne::Database.create(:document_specs)
  end

  describe "database selection" do
    it "should use the default database" do
      Throne::Document.database.should == :default
    end
    
    it "should set the database" do
      Throne::Document.database(:document_specs)
      Throne::Document.database.should == :document_specs
    end
    
    it "should raise an error" do
      lambda { Throne::Document.database(:not_setup) }.should raise_error(Throne::Database::NotSetup)
    end
    
    it "will use the default database" do
      TestDocumentWithDefault.database.should == :default
    end
  end

  describe "crud" do
    describe "with class methods" do   
      before :all do
        @doc = TestDocument.create(:field => true)
      end    

      it "should create a document" do
        TestDocument.create(:field => true).should be_an_instance_of(TestDocument)
      end

      it "should get a document" do
        TestDocument.get(@doc._id).should == @doc
      end
      
      it "should get a document with params" do
        RestClient.should_receive(:get).with(/descending=true/, anything())
        TestDocument.get(@doc._id, {:descending => true}).should be_an_instance_of(TestDocument)
      end
      
      it "should get a specific revision" do
        rev = @doc._rev
        @doc.save # Create a new revision
        TestDocument.get(@doc._id, {:rev => rev}).should_not == @doc
      end

      it "should destroy a document" do
        doc = TestDocument.create(:field => true)
        TestDocument.destroy(doc._id).should be_true
        lambda { TestDocument.get(doc._id) }.should raise_error(Throne::Document::NotFound)
        TestDocument.destroy(doc._id).should be_true # subseqent destroys should not raise.
      end
      
    end
  end
  
  describe "instance" do    
    before :each do
      @doc = TestDocument.create(:field => true)
    end
    
    it "should be a new_document" do
      TestDocument.new(:field => true).new_record?.should be_true
    end
    
    it "should not be a new_document" do
      TestDocument.create(:field => true).new_record?.should be_false
    end
    
    it "should have an _id" do
      @doc._id.should == @doc[:_id]
    end
    
    it "should have a _rev" do
      @doc._rev.should_not be_nil
    end
      
    it "should have a ruby class" do
      @doc.ruby_class.should == "TestDocument"
    end
    
    it "should not have 'ok'" do
      @doc.should_not have_key(:ok)
    end
    
    it "should be able to update an existing document" do
      @doc.field = false
      @doc.save
      @doc.field.should be_false
    end
    
    it "should not have id and rev after save" do
      @doc.save
      @doc.id.should_not == @doc._id # object_id
      @doc.rev.should be_nil
    end
    
    it "should not create a new object with subsequent saves" do
      @doc.save.should == @doc
    end
    
    describe "comparison" do
      it "should be the same" do
        @doc.should == @doc
      end
      
      it "should not be the same" do
        @doc.should_not == TestDocument.create(:field => true)
      end
    end

    it "should destroy the document" do
      @doc.destroy.should be_true
      lambda { TestDocument.get(@doc._id) }.should raise_error(Throne::Document::NotFound)
      @doc.destroy.should be_true # subseqent destroys should not raise.
    end
  end
end
