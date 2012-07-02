require 'clockwork'
require 'queue_classic'

# tell queue classic where our db is
ENV['DATABASE_URL'] = 'postgres://localhost/db_name_here'

module Clockwork

  handler do |job|
    QC.enqueue(job)
    puts "enqueued (depth #{QC.count}) - #{job}"
  end

  every(1.minute, 'Model.class_method_here')

  # don't stomp the queue
  every(5.minutes, 'Model.class_method_here', :if => lambda { |_| QC.count < 10 })

  # 1am cron task
  every(1.day, 'Model.class_method_here', :at => '01:00')

end
