class Transcription < ApplicationRecord
  belongs_to :chapter
  has_one_attached :audio

  enum :status, {
    pending: "pending",
    processing: "processing",
    completed: "completed",
    failed: "failed"
  }
end
