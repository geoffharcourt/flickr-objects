require "spec_helper"

describe "upload", :vcr do
  context "synchronous" do
    before(:each) { @response = Flickr.upload file("photo.jpg") }

    it "returns a valid photo ID" do
      expect {
        Flickr.photos.find(@response).get_info!
      }.to_not raise_error
    end

    after(:each) { Flickr.photos.delete(@response) }
  end

  context "asynchronous" do
    before(:each) { @response = Flickr.upload file("photo.jpg"), async: 1 }

    it "returns a valid ticket ID" do
      ticket = Flickr.upload_tickets.check(@response).find(@response)
      ticket.should_not be_invalid
    end

    after(:each) {
      # sleep 3
      Flickr.upload_tickets.check(@response).find(@response).photo.delete
    }
  end
end
