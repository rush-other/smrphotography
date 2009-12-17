ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Install the default route as the lowest priority.
  map.connect '/', :controller => 'gallery', :action => 'home'
  map.connect ':action.:format', :controller => 'gallery'
  map.connect ':action', :controller => 'gallery'
  map.connect 'galleries/:client.:format', :controller => 'gallery', :action => 'client_gallery'
  map.connect 'galleries/:client', :controller => 'gallery', :action => 'client_gallery'
  
  map.connect ':controller/:action.:format'
  map.connect ':controller/:action'
  
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  
end
