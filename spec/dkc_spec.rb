RSpec.describe Dkc do
  it "has a version number" do
    expect(Dkc::VERSION).not_to be nil
  end

  it "runs the start command" do
    content = capture(:stdout) { Dkc::Main.start }
    expect(content.strip).to eq("Commands:\n  rspec bash            # Start Bash on main container\n  \
rspec down            # Stopping and removing containers\n  \
rspec help [COMMAND]  # Describe available commands or one specific command\n  \
rspec start           # Start containers\n  \
rspec stop            # Stop containers\n  \
rspec up              # Provision containers")
  end
end
