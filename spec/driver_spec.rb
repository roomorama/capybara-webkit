require 'spec_helper'
require 'capybara/driver/webkit'

describe Capybara::Driver::Webkit do
  let(:hello_app) do
    lambda do |env|
      body = <<-HTML
        <html><body>
          <script type="text/javascript">
            document.write("he" + "llo");
          </script>
        </body></html>
      HTML
      [200,
        { 'Content-Type' => 'text/html', 'Content-Length' => body.length.to_s },
        [body]]
    end
  end

  subject { Capybara::Driver::Webkit.new(hello_app) }
  after { subject.reset! }

  it "finds content after loading a URL" do
    subject.visit("/hello")
    subject.find("//*[contains(., 'hello')]").should_not be_empty
  end

  it "has an empty page after reseting" do
    subject.visit("/")
    subject.reset!
    subject.find("//*[contains(., 'hello')]").should be_empty
  end
end
