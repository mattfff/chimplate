require "mailchimp"
require "yaml"

module Chimplate
  class Base
    def self.write_config(config, force = false)
      FileUtils.rm destination if force
      
      return false if File.exist? destination
      
      File.open(destination, "w+") do |file|
        file.write(config.to_hash.to_yaml)
      end
    end

    def self.pull(options = {})
      api.templates["user"].each do |template_info|
      template = api.templateInfo "tid" => template_info["id"]
      filename = Dir.pwd + "/" + template_info["id"].to_s + "-" + sanitize_filename(template_info["name"]) + ".html"

      write = true
      if File.exist? filename
        if options[:force] || yield(filename)
          FileUtils.rm filename 
        else
          puts "Skipping #{filename}.\n"
          write = false
        end
      end

      if write
        File.open(filename, "w+") do |file|
          file.write(template["source"])
          puts "Saved template #{filename}.\n";
        end
      end
    end
    end

    def self.push
      Dir.glob("*-*.html").each do |template_filename|
        push_file(template_filename)
      end
    end

    def self.push_file(template_filename)
      tid, template_name = template_filename.gsub(".html", "").split("-")

      File.open template_filename, "rb" do |file|
        if tid == "new"
          new_tid = api.templateAdd :name => template_name.gsub("_", " "), :html => file.read
          new_filename = new_tid.to_s + '-' + template_name + ".html"
          FileUtils.mv template_filename, new_filename

          puts "Saved new template #{new_filename}.\n";
        else
          api.templateUpdate "id" => tid, "values" => { "html" => file.read }
          puts "Updated template #{template_filename}.\n";
        end
      end
    end

    protected
      def self.api
        if !File.exist? destination
          puts "No config file here, please run `chimplate setup` first"
          exit
        else
          config = YAML.load_file(destination)
        end

        @api ||= Mailchimp::API.new config["api_key"]
      end

      def self.destination
        Dir.pwd + "/" + ".chimplate"
      end

      #from http://stackoverflow.com/questions/1939333/how-to-make-a-ruby-string-safe-for-a-filesystem
      def self.sanitize_filename(filename)
        # Split the name when finding a period which is preceded by some
        # character, and is followed by some character other than a period,
        # if there is no following period that is followed by something
        # other than a period (yeah, confusing, I know)
        fn = filename.split(/(?<=.)\.(?=[^.])(?!.*\.[^.])/m)

        # We now have one or two parts (depending on whether we could find
        # a suitable period). For each of these parts, replace any unwanted
        # sequence of characters with an underscore
        fn.map! { |s| s.gsub(/[^a-z0-9\-]+/i, '_') }

        # Finally, join the parts with a period and return the result
        return fn.join '.'
      end

  end

end
