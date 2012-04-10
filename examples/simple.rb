####################################################################
# Simple master-worker example
####################################################################
$:.unshift ::File.dirname(__FILE__) + '/../lib'

require 'rubygems'
require 'raemon'

class Test
  include Raemon::Worker
  
  def start
    super
  end

  def stop
    super
  end

  def run
    x = 0
    
    loop do
      logger.warn "I'm executing #{x}.. #{Process.ppid}:#{Process.pid}"
      
      if x < 3
        sleep 2
      else
        sleep 6
      end
      
      heartbeat!
      
      x += 1
    end
  end
end

Raemon::Master.start 2, Test, :timeout => 5
