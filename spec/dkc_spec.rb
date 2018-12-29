RSpec.describe Dkc do
  it "has a version number" do
    expect(Dkc::VERSION).not_to be nil
  end

  it "runs the start command" do
    expect(Dkc::Main.start).to be_truthy
  end
end
