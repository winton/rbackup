class RBackup
  
  @@usage = <<-USAGE
  Usage:
    rbackup [YAML] PROFILE
    
    YAML
      The path to your YAML configuration file.

      Default: ~/.rbackup.yml
      Example: mate #{File.expand_path(File.dirname(__FILE__) + '/../spec/fixtures/rbackup.yml')}

    PROFILE
      The name of the profile listed in your YAML configuration.
  USAGE
  
  attr_accessor :config, :destination, :exclude, :profile, :source
  
  def initialize(*args)
    if @profile = args.pop
      @config = args.pop || File.expand_path("~/.rbackup.yml")
      configure
    else
      error("You must specify a profile.")
    end
  end
  
  def configure
    if File.exists?(@config)
      yaml = File.open(@config)
      yaml = YAML::load(yaml)
      yaml = yaml[profile]
      fix = lambda { |path| path.gsub ' ', '\ '}
      @destination = fix.call(yaml['destination'])
      @exclude = yaml['exclude'].to_a.collect &fix
      @source = yaml['source'].to_a.collect &fix
    else
      error("YAML configuration not found.")
    end
  end
  
  def error(e)
    "  Error:\n    #{e}\n#{@@usage}"
    exit
  end
  
  def run
    options = "--numeric-ids -EaxzS"
    # --numeric-ids               don't map uid/gid values by user/group name
    # -E, --extended-attributes   copy extended attributes, resource forks
    # -a, --archive               recursion and preserve almost everything (-rlptgoD)
    # -x, --one-file-system       don't cross filesystem boundaries
    # -z, --compress              compress file data during the transfer
    # -S, --sparse                handle sparse files efficiently
    
    ex = exclude.collect { |e| "--exclude='#{e}'" }.join(' ')
    # --exclude=PATTERN           use one of these for each file you want to exclude
    
    `rsync #{options} #{ex} #{source.join(' ')} #{destination}`
  end
end