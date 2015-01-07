require 'fast_spec_helper'
require 'lib/job_queue'

describe JobQueue do
  describe '.push' do
    it 'enqueues a Resque job' do
      job_class = double(:job_class)
      allow(job_class).to receive(:perform_later)

      JobQueue.push(job_class, 1, 2, 3)

      expect(job_class).to have_received(:perform_later).with(1, 2, 3)
    end
  end
end
