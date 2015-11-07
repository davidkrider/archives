ActiveAdmin.register Recording do

  config.sort_order = "filename_asc"

  index do
    column :service do |r|
      link_to r.service.date_of_service, admin_service_path(r.service)
    end
    column :filename
    column :plot
    column :status
    default_actions
  end

  filter :service
  filter :filename
  
  form do |f|
    f.inputs do
      f.input :service, collection: Hash[Service.all.map{ |s| [s.date_of_service, s.id] }]
      f.input :filename
      f.input :plot
      f.input :status
    end
    f.actions
  end

end