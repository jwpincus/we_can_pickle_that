class Item < ApplicationRecord
  has_many :category_items
  has_many :categories, through: :category_items
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews

  has_attached_file :image,
    styles: { medium: "200x200>", small: "100x100>" },
    default_url: "picolas_cage.jpg"

  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  validates :price, presence: true, :numericality => {greater_than: 0}
  validates :description, presence: true
  validates :title, presence: true, uniqueness: true

  def update_paperclip_image
    update(image_url: image.url)
  end


  def self.most_reviewed_item
    Item.find(Review.group(:item_id).count.max_by { |k, v| v}.first) unless Review.count == 0
  end

  def self.most_expensive_item
    Item.find_by(price: Item.maximum(:price))
  end



end
