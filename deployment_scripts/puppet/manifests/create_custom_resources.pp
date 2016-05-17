notice("MODULAR: create_custom_resources.pp")
define myresources {
  if is_hash($name) and size($name)>0{
    create_resources($name['type'], $name['hash'])
  }
}

$custom_resources = hiera('custom_resources', {'yaml'=>[]})
$additional_resources = $custom_resources['yaml']
myresources{$additional_resources:}

