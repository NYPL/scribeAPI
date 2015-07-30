class SubjectSet
  include Mongoid::Document
  include Mongoid::Timestamps
  include Randomizer

  paginates_per 2

  field :name,                   type: String
  field :random_no ,             type: Float
  field :state ,                 type: String, default: "active"
  field :thumbnail,              type: String
  field :meta_data,              type: Hash
  field :counts,                 type: Hash

  belongs_to :group
  belongs_to :project
  has_many :subjects, dependent: :destroy, :order => [:order, :asc]

  # AMS: should a subject_set belong to a workflow, or do we get that throught the subject?
  # I think this is being used in the rake load_group_subjects around line133
  def activate!
    state = "active"
    workflows.each{|workflow| workflow.inc(:active_subjects => 1 )}
    save
  end

  def inc_subject_count_for_workflow(workflow)
    self.inc("counts.#{workflow.id.to_s}.total_subjects" => 1)
  end

  def subject_deactivated_on_workflow(workflow)
    inc_subjects_on_workflow(workflow, -1)
  end

  def subject_activated_on_workflow(workflow)
    inc_subjects_on_workflow(workflow, 1)
  end

  def inc_subjects_on_workflow(workflow, inc)
    self.inc("counts.#{workflow.id.to_s}.active_subjects" => inc)
  end

  def subject_completed_on_workflow(workflow)
    self.inc("counts.#{workflow.id.to_s}.complete_subjects" => +1)
    self.inc("counts.#{workflow.id.to_s}.active_subjects" => -1)
  end

  # AMS: what is this for?
  def active_subjects_for_workflow(workflow)
    subject.active.for_workflow(workflow)
  end

  def self.autocomplete_name(letters)
    reg = /#{Regexp.escape(letters)}/i
    where( :"meta_data.name" => reg)
  end

end
