class Orchestrator_api::Jobs

  def initialize(http, api_url_base)
    @https = http
    @api_url_base = api_url_base
  end

  def all(limit=nil)
    url = "#{@api_url_base}/jobs"
    if limit
      url << "?limit=#{limit}"
    end

    @https.get(url)
  end

  def details(id)
    @https.get("#{@api_url_base}/jobs/#{id}")
  end

  def nodes(id)
    @https.get("#{@api_url_base}/jobs/#{id}/nodes")
  end

  def report(id)
    @https.get("#{@api_url_base}/jobs/#{id}/report")
  end

  def events(id, start = nil)
    url = "#{@api_url_base}/jobs/#{id}/events"
    if start
      url << "?start=#{start}"
    end

    @https.get(url)
  end
end
