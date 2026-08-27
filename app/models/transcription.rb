class Transcription < ApplicationRecord
  belongs_to :chapter
  has_one_attached :audio

  enum :status, {
    chunking: "chunking",
    processing: "processing",
    completed: "completed",
    failed: "failed"
  }
end
