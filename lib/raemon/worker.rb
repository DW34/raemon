module Raemon
  module Worker
    def self.included(base)
      base.send :include, InstanceMethods
      base.send :include, Instrumentation
    end

    module InstanceMethods
      attr_reader :master, :logger, :id, :pulse
      attr_accessor :pid

      def initialize(master, id, pulse)
        @master = master
        @logger = master.logger
        @id     = id
        @pulse  = pulse
      end

      def ==(other_id)
        @id == other_id
      end

      def start
        logger.info "=> Starting worker (PID: #{pid}, ID: #{id})"
        instrument 'worker.start', :pid => pid
      end

      def stop
        logger.info "=> Stopping worker (PID: #{pid}, ID: #{id})"
        instrument 'worker.stop', :pid => pid
      end

      def run
        raise NotImplementedError, "must be implemented in your class"
      end

      def memory_usage
        usage = `ps -o rss= -p #{pid}`.to_i
        instrument 'worker.memory_usage', :pid => pid, :memory_used => usage
        return usage
      end

      def heartbeat!
        master.worker_heartbeat!(self)
      end
    end
  end
end
