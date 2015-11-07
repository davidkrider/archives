ActiveAdmin.register Service do

  config.sort_order = "date_of_service_desc"

  index do
    column :date_of_service
    column :title
    column :kind
    column :speakers do |service|
      service.speakers.collect { |sp| link_to sp.full_name, admin_speaker_path(sp) }.to_sentence.html_safe
    end
    default_actions
  end

  filter :date_of_service
  filter :title
  filter :kind
  
  form do |f|
    f.inputs do
      f.input :date_of_service, start_year: 1984
      f.input :title
      f.input :kind
      f.input :speakers, collection: Speaker.order(:last_name, :first_name), input_html: { size: 25 }
    end
    f.actions
  end

end
