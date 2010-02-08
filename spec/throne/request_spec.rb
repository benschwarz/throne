require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Throne::Request do
  before :all do
    @host = "http://127.0.0.1:5984"
    @db = "throne-request-specs"
    Throne::Database.setup(:throne_request_specs, "http://127.0.0.1:5984/throne-request-specs")
  end
  
  it "should make all requests asking for gzip and deflate" do
    RestClient.should_receive(:put).with("#{@host}/#{@db}/", "{}", { :accept_encoding  => "gzip, deflate" })
    Throne::Database.create(:throne_request_specs)
  end
  
  shared_examples_for "paramification" do    
    it "should be json encoded" do
      RestClient.should_receive(:get).with("#{@host}/#{@db}/document?startkey=%5B%22abc%22%2C%22xyz%22%5D", {:accept_encoding=>"gzip, deflate"})
      Throne::Request.get :database => :throne_request_specs, :resource => "document", :params => {:startkey => ["abc", "xyz"]}
    end
    
    it "should json encode abstract param keys (non-couchy params)" do
      RestClient.should_receive(:get).with("#{@host}/#{@db}/document?net=%5B%22abc%22%2C%22xyz%22%5D", {:accept_encoding=>"gzip, deflate"})
      Throne::Request.get :database => :throne_request_specs, :resource => "document", :params => {:net => ["abc", "xyz"]}
    end
    
    it "should uri escape each param value" do
      RestClient.should_receive(:get).with("#{@host}/#{@db}/document?descending=true", {:accept_encoding=>"gzip, deflate"})
      Throne::Request.get :database => :throne_request_specs, :resource => "document", :params => {:descending => true}
    end
    
    it "should join using an &" do
      RestClient.should_receive(:get).with(/&/, {:accept_encoding=>"gzip, deflate"})
      Throne::Request.get :database => :throne_request_specs, :resource => "document", :params => {:descending => true, :limit => 1}
    end
  end
  
  describe "get" do
    describe "expectations" do
      it_should_behave_like "paramification"
    end
    
    it "should get" do
      RestClient.should_receive(:get).with("#{@host}/#{@db}/document", {:accept_encoding=>"gzip, deflate"})
      Throne::Request.get(:resource => "document", :database => :throne_request_specs)
    end
  end
  
  describe "delete" do
    describe "expectations" do
      it_should_behave_like "paramification"
    end
    
    it "should delete" do
      RestClient.should_receive(:delete).with("#{@host}/#{@db}/document", {:accept_encoding=>"gzip, deflate"})
      Throne::Request.delete(:resource => "document", :database => :throne_request_specs)
    end
  end
  
  describe "put" do
    it "should put" do
      RestClient.should_receive(:put).with("#{@host}/#{@db}/document", "{}", {:accept_encoding=>"gzip, deflate"})
      Throne::Request.put(:resource => "document", :database => :throne_request_specs)
    end
  end
  
  describe "post" do
    it "should post" do
      RestClient.should_receive(:post).with("#{@host}/#{@db}/document", "{}", {:accept_encoding=>"gzip, deflate"})
      Throne::Request.post(:resource => "document", :database => :throne_request_specs)
    end
  end
end