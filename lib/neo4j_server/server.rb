# This code is heavily influenced by sunspot_solr's server.rb

require 'tempfile'
require 'neo4j_server/java'

module Neo4jServer
  class Server
    ServerError = Class.new(RuntimeError)
    JavaMissing = Class.new(ServerError)

    attr_accessor :data_dir, :log_dir, :neo4j_home, :port

    def initialize(*args)
      ensure_java_installed
      super(*args)
    end

    def run
      make_data_dir
      make_log_dir

      cmd =  ["java"]
      cmd << "-server"
      cmd << "-cp '#{jars.join(':')}'"
      cmd << "-Dlog4j.configuration=file:#{log4j_config_path}"
      cmd << "-Dorg.neo4j.server.properties=\"#{neo4j_server_properties_path}\""
      # cmd << "-Djava.util.logging.config.file=\"#{logging_config_path}\""
      cmd << "-Dneo4j.home=\"#{@neo4j_home}\""
      cmd << "-Dneo4j.instance=\"#{@neo4j_home}\""
      cmd << "-Duser.home=\"#{@neo4j_home}\""
      cmd << "org.neo4j.server.Bootstrapper"

      exec(cmd.join(" "))
    end

    def logging_config_path
      File.expand_path(@neo4j_home.join("conf/loggging.properties"))
      # return @logging_config_path if defined?(@logging_config_path)
      # @logging_config_path =
      #   if log_file
      #     logging_config = Tempfile.new('logging.properties')
      #     logging_config.puts("handlers = java.util.logging.FileHandler")
      #     # logging_config.puts("java.util.logging.FileHandler.level = #{'INFO'}")
      #     # logging_config.puts("java.util.logging.FileHandler.pattern = #{log_file}")
      #     logging_config.puts("java.util.logging.FileHandler.formatter = java.util.logging.SimpleFormatter")
      #     logging_config.flush
      #     logging_config.close
      #     logging_config.path
      #   end
    end

    private
    def log_file
      @log_dir.join("neo4j.log")
    end

    def ensure_java_installed
      unless defined?(@java_installed)
        @java_installed = Neo4jServer::Java.installed?
        unless @java_installed
          raise JavaMissing.new("You need a Java Runtime Environment to run the Solr server")
        end
      end
      @java_installed
    end

    def jars
      lib_jars         = Dir.glob(@neo4j_home.join("lib/*.jar"))
      sys_jars         = Dir.glob(@neo4j_home.join("system/lib/*.jar"))
      plugin_jars      = Dir.glob(@neo4j_home.join("plugins/*.jar"))
      coordinator_jars = Dir.glob(@neo4j_home.join("system/coordinator/lib/*.jar"))

      [lib_jars,sys_jars,plugin_jars,coordinator_jars].flatten.collect{|f| File.expand_path(f)}
    end

    def neo4j_instance
      @neo4j_home
    end

    def log4j_config_path
      File.expand_path(@neo4j_home.join("conf/log4j.properties"))
    end

    def neo4j_server_properties_path
      File.expand_path(@neo4j_home.join("conf/neo4j-server.properties"))
    end

    def make_data_dir
      FileUtils.mkdir_p(@data_dir)
    end

    def make_log_dir
      FileUtils.mkdir_p(@log_dir)
    end
  end
end