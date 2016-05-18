notice("MODULAR: create_custom_resources.pp")

define myresource (
  $node_roles,
  $resource = $name
){
  if is_hash($resource) and has_key($resource, 'node_roles') and
    has_key($resource, 'hash') and has_key($resource, 'type'){

    $roles_match = inline_template('<%
      result = ""
      @resource["node_roles"].each {|role|
        result << @node_roles.find { |e| e =~ /#{role}/ }.to_s
      }
      %><%= result %>')

    if size($roles_match)>0 {
      create_resources($resource['type'], $resource['hash'])
    }
  } else {
    warning("Improperly defined resource: $resource")
  }
}

# Main
$custom_resources = hiera('custom_resources', {})

# Compile YAML textarea input if any
if has_key($custom_resources, 'yaml'){
  myresources{parseyaml($custom_resources['yaml']):
    node_roles => hiera('roles'),
  }
}

# Compile YAML file input if any
if has_key($custom_resources, 'yaml_data'){
  myesources{parseyaml($custom_resources['yaml_data']):
    node_roles => hiera('roles'),
  }
}
