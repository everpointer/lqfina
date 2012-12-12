# config/initializers/source_maps.rb

if Rails.env.development?
  require 'open3'
  module CoffeeScript
    class SourceMapError < StandardError; end;

    class << self

      def map_dir
        return @map_dir if @map_dir
        # Make the directory the maps are served from
        @map_dir = Rails.root.join("public/source_maps")
        @map_dir.mkpath
        @map_dir
      end

      def check_coffeescript_version
        version = `coffee --version`

        unless version.match(/(\d+)\.\d+\./)[1].to_i >= 2
          raise "You must have coffeescript version 2.0.0-dev or higher to use source maps - see http://ryanflorence.com/2012/coffeescript-source-maps/"
        end
      end


      def compile script, options
        script = script.read if script.respond_to?(:read)

        if options.key?(:no_wrap) and !options.key?(:bare)
          options[:bare] = options[:no_wrap]
        else
          options[:bare] = false
        end

        check_coffeescript_version
        compile_with_source_map script, options
      end

      def compile_with_source_map script, options
        flags = %w(--js)
        flags << "--bare" if options[:bare]

        javascript, stderr, status = Open3.capture3("coffee #{flags.join(' ')}", stdin_data: script)

        raise SourceMapError, stderr unless status.success?

        source_map_comment = generate_source_map options[:pathname], script if options[:pathname]

        return javascript << source_map_comment

      rescue SourceMapError => e
        message = e.message.lines.first.chomp.gsub('"', '\"')
        relative_path_name = options[:pathname].to_s.gsub(Rails.root.to_s, '') if options[:pathname]
        relative_path_name ||= '<unknown path>'
        %Q{throw Error("Coffeescript compile error: #{relative_path_name}: #{message}")}
      end


      def generate_source_map pathname, script
        basename    = pathname.basename('.coffee')
        coffee_file = map_dir.join("#{basename}.coffee")
        coffee_file.open('w') {|f| f.puts script }


        # This command actually generates the source map, and saves it to a file
        source_map, status = nil
        Dir.chdir Rails.root.join('public/source_maps').to_s do
          source_map, stderr, status = Open3.capture3("coffee --source-map -i #{pathname.basename}")
        end

        raise SourceMapError, "Error while generating source map for file #{pathname}: #{stderr}" unless status.success?

        # I couldn't figure out how to control the 'file' and 'sources' values in the output,
        # so parse the map to JSON and rewrite these to ones that will work here
        data = JSON.parse(source_map)
        data['file'] = pathname.basename.to_s.gsub(/\.coffee/, '')
        data['sources'] = [pathname.basename.to_s]


        map_file = map_dir.join "#{basename}.map"
        map_file.open('w') { |f| f.puts data.to_json }
        Rails.logger.info "Compiled source map #{map_file}"

        return "\n//@ sourceMappingURL=/source_maps/#{map_file.basename}\n"
      end

    end
  end



  # Monkeypatch this method to include the scripts' pathname
  require 'tilt/template'

  module Tilt
    class CoffeeScriptTemplate < Template
      def evaluate(scope, locals, &block)
        @output ||= CoffeeScript.compile(data, options.merge(pathname: scope.pathname))
      end
    end
  end
end