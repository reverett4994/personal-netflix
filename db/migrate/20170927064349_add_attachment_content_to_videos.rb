class AddAttachmentContentToVideos < ActiveRecord::Migration
  def self.up
    change_table :videos do |t|
      t.attachment :content
    end
  end

  def self.down
    remove_attachment :videos, :content
  end
end
