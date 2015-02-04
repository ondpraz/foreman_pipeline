module Actions
  module Integration
    module Job
      class CreateJenkinsMainJob < CreateJenkinsJob
        def run
          create_jenkins_job(input[:job_id], input[:unique_name], shell_command(input[:host_ip], get_job))
        end

        def shell_command(ip, job)
          root_pass = "changeme"
          c = []
          # keys do not work for unknown reason
          # c << 'ssh-keygen -t rsa -N "" -f id_rsa'
          # c << "cat ./id_rsa.pub | sshpass -p #{root_pass} ssh root@#{ip} 'mkdir -p ~/.ssh && cat >>  ~/.ssh/authorized_keys'"
          c << "sshpass -p #{root_pass} ssh -o StrictHostKeyChecking=no root@#{ip}"
          c << "'"    
          c << add_repo_sources(job)
          c << ";"
          c << install_packages
          c << "'"
          c.join(" ")
        end

        def add_repo_sources(job)
          d = []
          job.repositories.each do |repo|
            d << "echo #{repos_d(repo, job)} > /etc/yum.repos.d/#{repo.name}.repo"            
          end
          d.join(";")
        end

        def install_packages
          d = ["yum -y install"]
          # input[:package_names].each { |packagename| d << "#{packagename}" }
          d.length == 1 ? "" : d.join(" ") 
        end

        def repos_d(repo, job)
          c = []
          c << '"'
          c << "[#{repo.name}]"
          c << "name=#{repo.name}"
          c << "baseurl=#{::Setting[:foreman_url]}/pulp/repos/#{job.organization.name}/#{job.environment.name}/#{job.content_view.name}/custom/#{repo.product.name}/#{repo.name}"
          c << "enabled=1"
          c << "gpgcheck=0"
          c << '"'
          c.join("\n")
        end

      end
    end
  end
end