require 'resque'

class JobQueue
  def self.push(job_class, *args)
    job_class.perform_later(*args)
  end
end
