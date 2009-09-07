class RBackup
  
  @@usage = <<-USAGE
  
  Usage:
    rbackup [PROFILE]...
    
    PROFILE
      The name of the profile listed in your YAML configuration.
  
  USAGE
  
  attr_accessor :profiles, :yaml
  
  def initialize(*args)
    @profiles = args
    configure
    if @profiles.empty?
      @profiles = @yaml.keys
    end
  end
  
  def configure
    if $TESTING
      config = SPEC + '/fixtures/rbackup.yml'
    else
      config = File.expand_path("~/.rbackup.yml")
    end
    if File.exists?(config)
      @yaml = File.open(config)
      @yaml = YAML::load(yaml)
    else
      error("YAML configuration not found.")
    end
  end
  
  def error(e)
    puts "\n  Error:\n    #{e}\n#{@@usage}"
    exit
  end
  
  def esc(paths)
    paths = paths.to_a
    paths.collect! { |path| path.gsub('SPEC', SPEC) } if $TESTING
    paths.collect  { |path| path.gsub(' ', '\ ') }.join(' ')
  end
  
  def run
    @profiles.each do |profile|
      if config = yaml[profile]
        destination = config['destination']
        exclude = config['exclude'].to_a
        source = config['source'].to_a

        FileUtils.mkdir_p destination

        options = "--numeric-ids -EaxzSv"
        # --numeric-ids               don't map uid/gid values by user/group name
        # -E, --extended-attributes   copy extended attributes, resource forks
        # -a, --archive               recursion and preserve almost everything (-rlptgoD)
        # -x, --one-file-system       don't cross filesystem boundaries
        # -z, --compress              compress file data during the transfer
        # -S, --sparse                handle sparse files efficiently
        # -v, --verbose               verbose

        ex = exclude.collect { |e| "--exclude='#{e}'" }.join(' ')
        # --exclude=PATTERN           use one of these for each file you want to exclude

        cmd = "rsync #{options} #{ex} #{esc(source)} #{esc(destination)}"
        if $TESTING
          `#{cmd}`
        else
          puts "Executing: #{cmd}"
          system(cmd)
        end
      else
        error("Profile #{profile} not found.")
      end
    end
  end
end