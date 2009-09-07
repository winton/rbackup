require File.expand_path("#{File.dirname(__FILE__)}/spec_helper")

describe RBackup do
  before(:each) do
    Dir[SPEC + '/fixtures/destination/*'].each do |path|
      FileUtils.rm_rf(path)
    end
  end
  
  it "should backup all profiles" do
    RBackup.new.run
    File.exists?(SPEC + '/fixtures/destination/1.txt').should == true
    File.exists?(SPEC + '/fixtures/destination/2.txt').should == false
    File.exists?(SPEC + '/fixtures/destination/3.txt').should == true
    File.read(SPEC + '/fixtures/destination/1.txt').should == '1'
    File.read(SPEC + '/fixtures/destination/3.txt').should == '3'
  end
  
  it "should backup profile_1" do
    RBackup.new('profile_1').run
    File.exists?(SPEC + '/fixtures/destination/1.txt').should == true
    File.exists?(SPEC + '/fixtures/destination/2.txt').should == false
    File.exists?(SPEC + '/fixtures/destination/3.txt').should == true
    File.read(SPEC + '/fixtures/destination/1.txt').should == '1'
    File.read(SPEC + '/fixtures/destination/3.txt').should == '3'
  end
  
  it "should backup profile_2" do
    RBackup.new('profile_2').run
    File.exists?(SPEC + '/fixtures/destination/1.txt').should == true
    File.exists?(SPEC + '/fixtures/destination/2.txt').should == false
    File.exists?(SPEC + '/fixtures/destination/3.txt').should == false
    File.read(SPEC + '/fixtures/destination/1.txt').should == '1'
  end
end
