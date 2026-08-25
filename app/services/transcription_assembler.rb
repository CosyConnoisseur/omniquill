class TranscriptionAssembler
  def self.call(results)
    new(results).call
  end

  def initialize(results)
    @results = results
  end

  def call
    ordered_results = @results.sort_by { |result| result[:index] }

    ordered_results
      .map { |result| result[:text] }
      .join("\n")
  end
end
