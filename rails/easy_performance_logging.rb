# In order to get the performance data we’re interested in, we add a set of
# listeners that subscribe to these performance events, format them the way we
# want, and then re-emit them. Our typical usage looks like:

ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |*args| 
  event = ActiveSupport::Notifications::Event.new(*args)
  controller = event.payload[:controller]
  action = event.payload[:action]
  format = event.payload[:format] || "all" 
  format = "all" if format == "*/*" 
  status = event.payload[:status]
  key = "#{controller}.#{action}.#{format}.#{ENV["INSTRUMENTATION_HOSTNAME"]}" 
  ActiveSupport::Notifications.instrument :performance, :action => :timing, :measurement => "#{key}.total_duration", :value => event.duration
  ActiveSupport::Notifications.instrument :performance, :action => :timing, :measurement => "#{key}.db_time", :value => event.payload[:db_runtime]
  ActiveSupport::Notifications.instrument :performance, :action => :timing, :measurement => "#{key}.view_time", :value => event.payload[:view_runtime]
  ActiveSupport::Notifications.instrument :performance, :measurement => "#{key}.status.#{status}" 
end

# Source: http://37signals.com/svn/posts/3091-pssst-your-rails-application-has-a-secret-to-tell-you
