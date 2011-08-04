module Builder
  class Base

    def initialize(config)
      @config = config
      @local_repo_path = File.join tmpdir, 'skynet'
    end

    def run
      raise "Must be implemented in subclass"
    end

    private

    def tmpdir
      @tmpdir ||= ENV["TMPDIR"] || File.join(File.dirname(__FILE__), '..', 'tmp')
    end

    def create_repo
      `rm -rf #{@local_repo_path}` if repo_exists?
      `mkdir -p #{tmpdir}; cd #{tmpdir}; git clone #{@config[:repository]} skynet`
    end

    def update_repo
      `cd #{@local_repo_path}; git pull`
    end

    def repo_exists?
      File.exist?(@local_repo_path)
    end
  end
end
