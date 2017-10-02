class OrchestratorClient::Jobs

  def initialize(http)
    @https = http
  end

  def all(limit=nil)
    url = "jobs"
    if limit
      url << "?limit=#{limit}"
    end

    @https.get(url)
  end

  def details(id)
    @https.get("jobs/#{id}")
  end

  def nodes(id)
    @https.get("jobs/#{id}/nodes")
  end

  def report(id)
    @https.get("jobs/#{id}/report")
  end

  def events(id, start = nil)
    url = "jobs/#{id}/events"
    if start
      url << "?start=#{start}"
    end

    @https.get(url)
  end
end
