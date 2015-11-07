ActiveAdmin.register Speaker do

  config.sort_order = "last_name_asc"

  index do
    column :salutation
    column :first_name
    column :last_name
    default_actions
  end

  filter :last_name
  filter :first_name
  
  form do |f|
    f.inputs do
      f.input :salutation
      f.input :first_name
      f.input :last_name
    end
    f.actions
  end

end