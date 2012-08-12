# ruby app.rb -p 9998

require 'goliath'

class EventGenerator < Goliath::API
  def response(env)
    EM.add_periodic_timer(1) do
      env.stream_send("Hello Mars ##{rand(100)} <<<")
    end

    EM.add_periodic_timer(3) do
      env.stream_send("Hello World ##{rand(100)} >>>")
    end

    streaming_response(200, {'Content-Type' => 'text/event-stream'})
  end
end


