require 'fileutils'
require 'yaml'

class RBackup
  
  @@usage = <<-USAGE
  
  Usage:
    rbackup [PROFILE]...
    
    PROFILE
      The name of the profile listed in your YAML configuration.
  
  USAGE
  
  attr_accessor :profiles, :yaml
  
  def initialize(*args)
    get_yaml
    get_profiles(args, @yaml)
  end
  
  def get_profiles(input, hash, force=false)
    @profiles ||= []
    hash.each do |key, value|
      next unless value.respond_to?(:keys)
      is_profile = value['source'] && value['destination']
      if input.include?(key) || input.empty? || force
        if is_profile
          @profiles << value
        else
          get_profiles(input, value, true)
        end
      elsif !is_profile
        get_profiles(input, value, force)
      end
    end
  end
  
  def get_yaml
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
    paths = [ paths ].flatten
    paths.collect! { |path| path.gsub('SPEC', SPEC) } if $TESTING
    paths.collect  { |path| path.gsub(' ', '\ ') }.join(' ')
  end
  
  def rsync(profile)
    inc1ude = []
    exclude = []
    destination = profile['destination']
    source = [ profile['source'] ].flatten

    options = "--delete --numeric-ids --safe-links -axzSvL"
    # --delete                    delete extraneous files from dest dirs
    # --numeric-ids               don't map uid/gid values by user/group name
    # --safe-links                ignore symlinks that point outside the tree
    # -a, --archive               recursion and preserve almost everything (-rlptgoD)
    # -x, --one-file-system       don't cross filesystem boundaries
    # -z, --compress              compress file data during the transfer
    # -S, --sparse                handle sparse files efficiently
    # -v, --verbose               verbose
    
    if destination.include?(':') || source.include?(':')
      options += ' -e ssh'
      # -e, --rsh=COMMAND         specify the remote shell to use
    else
      options += 'E'
      # -E, --extended-attributes copy extended attributes, resource forks
      FileUtils.mkdir_p destination
    end
    
    if profile['include']
      exclude = %w(*) unless profile['exclude']
      inc1ude = [ profile['include'] ].flatten
    end

    if profile['exclude']
      exclude += [ profile['exclude'] ].flatten
    end
    
    inc1ude = inc1ude.collect { |i| "--include='#{i}'" }.join(' ')
    exclude = exclude.collect { |e| "--exclude='#{e}'" }.join(' ')
    # --exclude=PATTERN         use one of these for each file you want to exclude
    # --include-from=FILE       don't exclude patterns listed in FILE

    cmd = "rsync #{options} #{inc1ude} #{exclude} #{esc(source)} #{esc(destination)}"
    if $TESTING
      `#{cmd}`
    else
      puts "Executing: #{cmd}"
      system(cmd)
    end
  end
  
  def run
    @profiles.each do |profile|
      rsync(profile)
    end
  end
end