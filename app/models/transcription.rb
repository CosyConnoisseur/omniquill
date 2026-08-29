class Transcription < ApplicationRecord
  belongs_to :chapter

  has_one_attached :audio

  enum :status, {
    chunking: "chunking",
    processing: "processing",
    summarizing: "summarizing",
    completed: "completed",
    failed: "failed",
    canceled: "canceled"
  }
end
