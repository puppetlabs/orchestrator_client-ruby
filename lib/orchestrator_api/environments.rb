class Orchestrator_api::Environments

  def initialize(https, api_url_base)
    @https = https
    @api_url_base = api_url_base
  end

  def all
    @https.get("#{api_url_base}/environments")
  end

  def applications(id)
    @https.get("#{api_url_base}/environments/#{id}/applications")
  end

  def instances(id)
    @https.get("#{api_url_base}/environments/#{id}/instances")
  end
end
