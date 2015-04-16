class User < ActiveRecord::Base
  after_create :destroy_invite_code
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :invite_code,
    on: :create,
    presence: :true,
    inclusion: { in: proc { InviteCode.where( used: false ).map( &:code ) }}

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :links

  private
  def destroy_invite_code
    @invite_code = InviteCode.find_by(code: self.invite_code)
    @invite_code['used'] = true
    @invite_code.save
  end

end
