module Actions
  module Integration
    module Jenkins
      class ConfigureJenkinsJob < Actions::EntryAction
        
        def run
          job = ::Integration::Job.find input.fetch(:job_id)
          job.init_run
          job.jenkins_instance.client.job.update_freestyle params_hash
        end

        def params_hash
          {}
        end

      end
    end
  end
end