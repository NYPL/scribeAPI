class ProjectSerializer < ActiveModel::MongoidSerializer
  attributes :id, :title, :short_title, :summary, :home_page_content, :organizations , :team, :pages, :logo, :background, :workflows, :forum, :tutorial, :feedback_form_url, :metadata_search
  has_many :workflows

  def id
    object._id.to_s
  end


end
