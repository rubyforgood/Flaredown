require "rails_helper"
require "sidekiq/testing"

# Requiring sidekiq/testing switches Sidekiq into fake mode for the whole suite;
# keep the default as-is and opt in per example group instead.
Sidekiq::Testing.disable!

RSpec.describe Api::V1::ProfilesController do
  let(:user) { create(:user) }
  let(:profile) { user.profile }
  let(:another_user) { create(:user) }
  let(:another_profile) { another_user.profile }

  describe "show" do
    context "when no user logged-in" do
      it "returns 302 (Permanent Redirect)" do
        get :show, params: {id: profile.id}
        expect(response.status).to eq 302
      end
    end

    context "when different user logged-in" do
      before { sign_in another_user }
      it "returns 401 (unauthorized)" do
        get :show, params: {id: profile.id}
        expect(response.status).to eq 401
      end
    end

    context "when user logged-in" do
      before { sign_in user }
      it "returns profile" do
        get :show, params: {id: profile.id}
        expect(response_body[:profile][:id]).to eq profile.id
      end

      context "with invalid profile id" do
        it "returns 404 (RecordNotFound)" do
          get :show, params: {id: "a123"}
          expect(response.status).to eq 404
        end
      end

      context "when different profile id is requested" do
        it "returns 401 (unauthorized)" do
          get :show, params: {id: another_profile.id}
          expect(response.status).to eq 401
        end
      end
    end
  end

  describe "update" do
    context "when user logged-in" do
      before { sign_in user }
      let(:profile_attributes) { attributes_for(:profile) }
      it "updates profile attributes" do
        put :update, params: {id: profile.id, profile: profile_attributes}
        updated_profile = response_body[:profile]
        expect(updated_profile[:id]).to eq profile.id
        expect(updated_profile[:country_id]).to eq profile_attributes[:country_id]
        expect(updated_profile[:sex_id]).to eq profile_attributes[:sex_id]
        expect(updated_profile[:birth_date]).to eq profile_attributes[:birth_date].to_date.to_s
      end
      context "with available locale for country" do
        before { profile_attributes[:country_id] = "IT" }
        it "sets the first country's language as locale" do
          put :update, params: {id: profile.id, profile: profile_attributes}
          expect(I18n.locale).to eq :it
        end
        after { I18n.locale = :en }
      end
      context "with unavailable locale for country" do
        before { profile_attributes[:country_id] = "IN" }
        it "sets locale to default" do
          put :update, params: {id: profile.id, profile: profile_attributes}
          expect(I18n.locale).to eq I18n.default_locale
        end
      end

      context "when some attribute is invalid" do
        before { profile_attributes[:sex_id] = "blah" }
        it "returns 422 (unprocessable_entity)" do
          put :update, params: {id: profile.id, profile: profile_attributes}
          expect(response.status).to eq 422
        end
      end
    end

    context "reminder scheduling" do
      before { sign_in user }

      around do |example|
        Sidekiq::Testing.fake! do
          CheckinReminderJob.clear
          example.run
        end
      end

      context "when the user opts out of reminders" do
        let(:opt_out_params) { {checkin_reminder: false, onboarding_reminder: true} }

        it "responds successfully without scheduling a reminder" do
          put :update, params: {id: profile.id, profile: opt_out_params}

          expect(response.status).to eq 200
          expect(CheckinReminderJob.jobs).to be_empty
        end

        it "clears a previously scheduled job id" do
          profile.update_column(:reminder_job_id, "stale-job-id")

          put :update, params: {id: profile.id, profile: opt_out_params}

          expect(profile.reload.reminder_job_id).to be_nil
        end
      end

      context "when the user picks a reminder time" do
        let(:reminder_params) do
          {
            checkin_reminder: true,
            onboarding_reminder: true,
            time_zone_name: "America/New_York",
            checkin_reminder_at: {hours: 20, minutes: 30}
          }
        end

        it "schedules a reminder and stores its job id" do
          put :update, params: {id: profile.id, profile: reminder_params}

          expect(response.status).to eq 200
          expect(CheckinReminderJob.jobs.size).to eq 1
          expect(profile.reload.reminder_job_id).to eq CheckinReminderJob.jobs.first["jid"]
        end

        it "passes only native JSON types to the job" do
          put :update, params: {id: profile.id, profile: reminder_params}

          profile_id, reminder_at = CheckinReminderJob.jobs.first["args"]
          expect(profile_id).to eq profile.id
          expect(reminder_at).to be_a String
          expect(Time.parse(reminder_at).utc.strftime("%H:%M")).to eq "20:30"
        end
      end
    end
  end
end
