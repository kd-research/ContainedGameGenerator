require_relative "proto/gamegenerator_services_pb"

class GameGeneratorService < GameGenerator::Service
  def initialize
    super
    puts "GameGeneratorService initialized"
  end

  def generate_game(_request, _unused_call)
    Dir.mktmpdir do |dir|
      puts "Generating game in #{dir}"
      build_command = ["/root/GenerateGame.sh"]
      build_command << dir
      system(*build_command)

      raise unless $?.success?

      GenerateGameResponse.new(
        loader: File.read("#{dir}/build/Build.loader.js"),
        data: File.read("#{dir}/build/Build.data.unityweb"),
        framework: File.read("#{dir}/build/Build.framework.js.unityweb"),
        code: File.read("#{dir}/build/Build.wasm.unityweb")
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
