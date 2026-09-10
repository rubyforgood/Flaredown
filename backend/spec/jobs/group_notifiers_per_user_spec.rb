require "rails_helper"

RSpec.describe GroupNotifiersPerUser do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }
  let(:notifier) { create(:user) }
  let(:notified_post) { create(:post, encrypted_user_id: user.encrypted_id) }

  let!(:notification) do
    create(:notification,
      kind: "comment",
      notificateable: notified_post,
      encrypted_user_id: notifier.encrypted_id,
      encrypted_notify_user_id: user.encrypted_id)
  end

  def run
    described_class.new.perform(user.encrypted_id)
  end

  it "mails the pending notifications to the user" do
    expect { run }.to have_enqueued_mail(NotificationsMailer, :notify)
  end

  it "marks what it mailed as delivered so it is not sent twice" do
    run

    expect(notification.reload.delivered).to be true
  end

  it "sends nothing when everything has already been delivered" do
    notification.update!(delivered: true)

    expect { run }.not_to have_enqueued_mail(NotificationsMailer, :notify)
  end

  it "sends nothing when the user has turned notifications off" do
    user.profile.update!(notify: false)

    expect { run }.not_to have_enqueued_mail(NotificationsMailer, :notify)
  end

  it "sends nothing when the address has already been rejected" do
    user.profile.update!(rejected_type: "bounce")

    expect { run }.not_to have_enqueued_mail(NotificationsMailer, :notify)
  end

  # The encrypted id is decrypted to find the user, so a value that is not valid
  # ciphertext is swallowed rather than crashing the worker.
  it "gives up quietly when the id is not decryptable" do
    expect { described_class.new.perform("not-real-ciphertext") }.not_to raise_error
  end
end
