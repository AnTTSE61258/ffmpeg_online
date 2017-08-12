class Request < ApplicationRecord
  mount_uploader :file, AttachmentUploader
end
