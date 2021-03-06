require "spec_helper"

describe Flickr do
  before(:each) { @it = Flickr }

  it "has a list of registered API methods" do
    @it.api_methods["flickr.photos.search"].should eq ["Flickr::Photo.search"]
    @it.api_methods["flickr.photos.delete"].should eq ["Flickr::Photo.delete", "Flickr::Photo#delete"]
  end

  it "has an interface" do
    @it.photos.should eq Flickr::Photo
  end

  it "has tests written for every implemented API method" do
    tested_api_methods = Dir[File.join(ROOT, "spec/flickr/api/**/*_spec.rb")].
      map { |api_spec| File.basename(api_spec).chomp("_spec.rb") }.
      select { |name| Flickr.api_methods.keys.include?(name) }

    (Flickr.api_methods.keys - tested_api_methods).should eq []
  end

  describe "instance" do
    before(:each) { @it = Flickr.new(nil, nil) }

    it "has clients" do
      @it.client.should be_a(Flickr::MethodsClient)
      @it.upload_client.should be_a(Flickr::UploadClient)
    end

    it "can has a different access token" do
      oauth(@it.client)[:token].should be_nil
      oauth(@it.client)[:token_secret].should be_nil
    end

    it "has the interface" do
      @it.photos.should eq Flickr::Photo
    end
  end
end
