require File.expand_path("#{File.dirname(__FILE__)}/spec_helper")

describe RBackup do
  before(:each) do
    @rb = RBackup.new(SPEC + '/fixtures/rbackup.yml', 'profile_1')
    # Replace SPEC in config paths
    replace = lambda { |s| s.gsub('SPEC', SPEC) }
    @rb.destination = replace.call(@rb.destination)
    @rb.exclude = @rb.exclude.collect &replace
    @rb.source = @rb.source.collect &replace
    # Empty destination folder
    Dir[SPEC + '/fixtures/destination/*'].each do |path|
      FileUtils.rm_rf(path)
    end
    # Debug
    # debug @rb.destination
    # debug @rb.exclude
    # debug @rb.source
  end
  
  it "should load the YAML configuration" do
    @rb.destination.should == "#{SPEC}/fixtures/destination"
    @rb.exclude.should == [ "2.txt" ]
    @rb.source.should == [ "#{SPEC}/fixtures/source/*" ]
  end
  
  it "should backup" do
    @rb.run
    File.exists?(SPEC + '/fixtures/destination/1.txt').should == true
    File.exists?(SPEC + '/fixtures/destination/2.txt').should == false
    File.read(SPEC + '/fixtures/destination/1.txt').should == '1'
  end
end
