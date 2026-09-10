require "rails_helper"

# `load_defaults 7.2` sets active_job.enqueue_after_transaction_commit to :default,
# which hands the decision to the queue adapter. Sidekiq keeps its queue in Redis
# rather than the Active Record database, so it takes the abstract adapter's `true`:
# a job enqueued inside a transaction waits for the commit, and a rollback drops it
# instead of leaving Sidekiq holding a job whose rows were never written.
#
# HelloWorldJob is used because it is inert -- nothing else references it, and
# performing it only writes a log line.
describe "enqueuing an Active Job inside an Active Record transaction" do
  include ActiveJob::TestHelper

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

  # DatabaseCleaner's :transaction strategy wraps every example in a transaction
  # opened with `joinable: false`, and ActiveRecord.after_all_transactions_commit
  # skips non-joinable transactions. So an enqueue outside an explicit transaction
  # still happens immediately, which is what the rest of the suite assumes.
  it "enqueues immediately outside a transaction" do
    HelloWorldJob.perform_later

    expect(enqueued_jobs.size).to eq(1)
  end
end
