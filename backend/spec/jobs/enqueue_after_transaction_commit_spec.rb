require "rails_helper"

# Rails 7.2 briefly let `config.active_job.enqueue_after_transaction_commit`
# defer every enqueue to after the surrounding transaction committed. Rails 8.0
# deprecated that global setting, dropped it from its own 7.2 defaults block and
# made the per-job default `false`, so enqueues are immediate again unless a job
# class opts in. These specs pin both halves of that, since the per-job setter
# is the part that survives into 8.1.
#
# HelloWorldJob is used because it is inert -- nothing else references it, and
# performing it only writes a log line.
describe "enqueuing an Active Job inside an Active Record transaction" do
  include ActiveJob::TestHelper

  context "by default" do
    it "enqueues without waiting for the commit" do
      ActiveRecord::Base.transaction do
        HelloWorldJob.perform_later

        expect(enqueued_jobs.size).to eq(1)
      end
    end

    it "keeps the job when the transaction rolls back" do
      ActiveRecord::Base.transaction do
        HelloWorldJob.perform_later

        raise ActiveRecord::Rollback
      end

      expect(enqueued_jobs.size).to eq(1)
    end
  end

  context "when the job opts in" do
    around do |example|
      previous = HelloWorldJob.enqueue_after_transaction_commit
      HelloWorldJob.enqueue_after_transaction_commit = true
      example.run
      HelloWorldJob.enqueue_after_transaction_commit = previous
    end

    it "waits for the transaction to commit" do
      ActiveRecord::Base.transaction do
        HelloWorldJob.perform_later

        expect(enqueued_jobs).to be_empty
      end

      expect(enqueued_jobs.size).to eq(1)
    end

    it "drops the job when the transaction rolls back" do
      ActiveRecord::Base.transaction do
        HelloWorldJob.perform_later

        raise ActiveRecord::Rollback
      end

      expect(enqueued_jobs).to be_empty
    end
  end

  # DatabaseCleaner's :transaction strategy wraps every example in a transaction
  # opened with `joinable: false`, and ActiveRecord.after_all_transactions_commit
  # skips non-joinable transactions. So even an opted-in job enqueues immediately
  # outside an explicit transaction, which is what the rest of the suite assumes.
  it "enqueues immediately outside a transaction" do
    HelloWorldJob.perform_later

    expect(enqueued_jobs.size).to eq(1)
  end
end
