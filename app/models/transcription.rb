class Transcription < ApplicationRecord
  belongs_to :chapter

  has_one_attached :audio

  enum :status, {
    chunking: "chunking",
    processing: "processing",
    transcribing: "transcribing",
    summarizing: "summarizing",
    completed: "completed",
    failed: "failed",
    canceled: "canceled"
  }
end
