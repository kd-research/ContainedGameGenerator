require "tempfile"
require_relative "proto/gamegenerator_services_pb"

class GameGeneratorService < Unitygen::GameGenerator::Service
  include Unitygen
  def initialize
    super
    puts "GameGeneratorService initialized"
  end

  def generate_game(_request, _unused_call)
    file = lambda do |path|
      FileResponse.new(data: File.read(path, mode: "rb"))
    end

    Dir.mktmpdir do |dir|
      puts "Generating game in #{dir}"
      build_command = ["/root/GenerateGame.sh"]
      build_command << dir
      r0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      logfile = `#{build_command.join(" ")} 2>&1`
      r1 = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      puts "#{dir}: Build time: #{r1 - r0} seconds"

      if $?.exitstatus != 0
        tmpfile = Tempfile.new(%w[unity-build-error- .log])
        tmpfile.write(logfile)
        tmpfile.close

        puts "Error building game, see #{tmpfile.path}"
        raise "Error building game"
      end

      build_base = "#{dir}/Build/Build"

      GenerateGameResponse.new(
        loader: file["#{build_base}/Build.loader.js"],
        data: file["#{build_base}/Build.data.unityweb"],
        framework: file["#{build_base}/Build.framework.js.unityweb"],
        code: file["#{build_base}/Build.wasm.unityweb"]
      )
    end
  end

  def self.run!(host: "0.0.0.0", port: "9451")
    server = GRPC::RpcServer.new
    puts "Starting server on #{host}:#{port}"
    server.add_http2_port("#{host}:#{port}", :this_port_is_insecure)
    server.handle(GameGeneratorService.new)
    server.run_till_terminated_or_interrupted([1, "int", "SIGQUIT"])
  end
end
