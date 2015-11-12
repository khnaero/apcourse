class Photo < ActiveRecord::Base
	belongs_to :location
	has_attached_file :image, styles: { large: "1100x880>", medium: "200x200>" }
	# has_attached_file :image,
 #    :path => ":rails_root/public/images/:id/:filename",
 #    :url  => "/images/:id/:filename"

	# do_not_validate_attachment_file_type :image
	validates_attachment :image, presence: true,
												content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'] },
												size: { less_than: 5.megabytes }
end
