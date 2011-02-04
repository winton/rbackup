require File.expand_path("#{File.dirname(__FILE__)}/spec_helper")

describe RBackup do
  [ :normal, :reverse ].each do |type|
    before(:each) do
      if type == :normal
        $rbackup_config = SPEC + '/fixtures/rbackup.yml'
        @reverse = false
      else
        $rbackup_config = SPEC + '/fixtures/rbackup_reverse.yml'
        @reverse = true
      end
      Dir[SPEC + '/fixtures/destination/*'].each do |path|
        FileUtils.rm_rf(path)
      end
    end
  
    it "should backup all profiles" do
      RBackup.new(@reverse).run
      File.exists?(SPEC + '/fixtures/destination/1.txt').should == true
      File.exists?(SPEC + '/fixtures/destination/2.txt').should == true
      File.exists?(SPEC + '/fixtures/destination/3.txt').should == true
      File.read(SPEC + '/fixtures/destination/1.txt').should == '1'
      File.read(SPEC + '/fixtures/destination/2.txt').should == '2'
      File.read(SPEC + '/fixtures/destination/3.txt').should == '3'
    end
  
    it "should backup profile_1" do
      RBackup.new(@reverse, 'profile_1').run
      File.exists?(SPEC + '/fixtures/destination/1.txt').should == false
      File.exists?(SPEC + '/fixtures/destination/2.txt').should == true
      File.exists?(SPEC + '/fixtures/destination/3.txt').should == true
      File.read(SPEC + '/fixtures/destination/2.txt').should == '2'
      File.read(SPEC + '/fixtures/destination/3.txt').should == '3'
    end
  
    it "should backup profile_2" do
      RBackup.new(@reverse, 'profile_2').run
      File.exists?(SPEC + '/fixtures/destination/1.txt').should == true
      File.exists?(SPEC + '/fixtures/destination/2.txt').should == false
      File.exists?(SPEC + '/fixtures/destination/3.txt').should == true
      File.read(SPEC + '/fixtures/destination/1.txt').should == '1'
      File.read(SPEC + '/fixtures/destination/3.txt').should == '3'
    end
  
    it "should backup profile_3" do
      RBackup.new(@reverse, 'profile_3').run
      File.exists?(SPEC + '/fixtures/destination/1.txt').should == false
      File.exists?(SPEC + '/fixtures/destination/2.txt').should == true
      File.exists?(SPEC + '/fixtures/destination/3.txt').should == true
      File.read(SPEC + '/fixtures/destination/2.txt').should == '2'
      File.read(SPEC + '/fixtures/destination/3.txt').should == '3'
    end
  
    it "should backup profile_6" do
      RBackup.new(@reverse, 'profile_6').run
      File.exists?(SPEC + '/fixtures/destination/1.txt').should == false
      File.exists?(SPEC + '/fixtures/destination/2.txt').should == true
      File.exists?(SPEC + '/fixtures/destination/3.txt').should == true
      File.read(SPEC + '/fixtures/destination/2.txt').should == '2'
      File.read(SPEC + '/fixtures/destination/3.txt').should == '3'
    end
  end
end
