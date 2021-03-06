module Actions
  module ForemanPipeline
    module Jenkins
      class List < AbstractJenkinsAction
        def run
          output[:projects] = job.jenkins_instance.client.job.list input[:filter]
        end

        def humanized_name
          "List projects in Jenkins Instance: %s" % job.jenkins_instance.name
        end
      end
    end
  end
end