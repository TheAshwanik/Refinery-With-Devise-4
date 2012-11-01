ActiveAdmin.register User, :as => "User" do

  config.batch_actions = true

  filter :email
  filter :created_at

  index do
    selectable_column
    id_column
    column :email
    column :created_at
    default_actions
  end

  show :title => :email do
    panel "Order History" do
      table_for(user.orders) do
        column("Order", :sortable => :id) {|order| link_to "##{order.id}", admin_order_path(order) }
        column("State") {|order| status_tag(order.state) }
        column("Date", :sortable => :checked_out_at){|order| pretty_format(order.checked_out_at) }
        column("Total") {|order| number_to_currency order.total_price }
      end
    end
    active_admin_comments
  end

  sidebar "User Details", :only => :show do
    attributes_table_for user, :username, :email, :created_at
  end

  sidebar "Order History", :only => :show do
    attributes_table_for user do
      row("Total Orders") { user.orders.complete.count }
      row("Total Value") { number_to_currency user.orders.complete.sum(:total_price) }
    end
  end

  sidebar "Active Admin Demo" do
    #render('/admin/sidebar_links', :model => 'users')
  end
end