module Raemon
  # Provides a safe interface to instrument Raemon
  module Instrumentation
    def instrument(name, payload={}, &block)
      if Raemon.config.instrumentor.respond_to? :instrument
        full_name = "#{Raemon.config.instrumentor_name}.#{name}"
        Raemon.config.instrumentor.send :instrument, full_name, payload, &block
      end
    end
  end
end
