notice("MODULAR: create_custom_resources.pp")

define myresource (
  $node_roles,
  $resource = $name
){

  $roles_match = inline_template('<%
    result = ""
    @resource["node_roles"].each {|role|
      result << @node_roles.find { |e| e =~ /#{role}/ }.to_s
    }
    %><%= result %>')

  if is_hash($resource) and has_key($resource, 'node_roles') and
     size($roles_match)>0 {
    create_resources($resource['type'], $resource['hash'])
  }
}

$custom_resources = hiera('custom_resources', {})

if has_key($custom_resources, 'yaml'){
  $additional_resources = parseyaml($custom_resources['yaml'])
  myresources{$additional_resources:
    node_roles => hiera('roles'),
  }
}
